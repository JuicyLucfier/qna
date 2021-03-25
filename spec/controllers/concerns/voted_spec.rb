require 'rails_helper'

shared_examples 'voted_answer' do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question, author: author) }
  let(:vote) { create(:vote, value: "for", votable: answer, user: user) }

  describe 'PATCH #vote_for, #vote_against, #vote_cancel' do
    context 'user' do
      before { login(user) }

      let!(:answer) { create(:answer, question: question, author: author) }

      context 'answer is not voted' do
        it 'votes for answer' do
          patch :vote_for, params: { id: answer }, format: :json
          answer.reload

          expect(answer.rating).to eq 1
        end

        it 'votes against answer' do
          patch :vote_against, params: { id: answer }, format: :json
          answer.reload

          expect(answer.rating).to eq -1
        end

        it 'responds with json' do
          patch :vote_for, params: { id: answer }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'answer is voted' do
        it "cancels answer's vote" do
          user.votes.push(vote)
          answer.votes.push(vote)
          answer.rating = 1
          answer.save

          patch :vote_cancel, params: { id: answer }, format: :json
          answer.reload

          expect(answer.rating).to eq 0
        end

        it 'responds with json' do
          patch :vote_for, params: { id: answer }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'author' do
      before { login(author) }
      let!(:answer) { create(:answer, question: question, author: author) }

      it 'tries to vote for answer' do
        expect { patch :vote_for, params: { id: answer }, format: :json }.to_not change(answer, :rating)
      end

      it 'tries to vote against answer' do
        expect { patch :vote_against, params: { id: answer }, format: :json }.to_not change(answer, :rating)
      end
    end
  end
end

shared_examples 'voted_question' do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:vote) { create(:vote, value: "for", votable: question, user: user) }

  describe 'PATCH #vote_for, #vote_against, #vote_cancel' do
    context 'user' do
      before { login(user) }

      let!(:question) { create(:question, author: author) }

      context 'question is not voted' do
        it 'votes for question' do
          patch :vote_for, params: { id: question }, format: :json
          question.reload

          expect(question.rating).to eq 1
        end

        it 'votes against question' do
          patch :vote_against, params: { id: question }, format: :json
          question.reload

          expect(question.rating).to eq -1
        end

        it 'responds with json' do
          patch :vote_for, params: { id: question }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end

      context 'question is voted' do
        it "cancels question's vote" do
          user.votes.push(vote)
          question.votes.push(vote)
          question.rating = 1
          question.save

          patch :vote_cancel, params: { id: question }, format: :json
          question.reload

          expect(question.rating).to eq 0
        end

        it 'responds with json' do
          patch :vote_for, params: { id: question }, format: :json
          expect(response.content_type).to eq('application/json; charset=utf-8')
        end
      end
    end

    context 'author' do
      before { login(author) }
      let!(:question) { create(:question, author: author) }

      it 'tries to vote for question' do
        expect { patch :vote_for, params: { id: question }, format: :json }.to_not change(question, :rating)
      end

      it 'tries to vote against question' do
        expect { patch :vote_against, params: { id: question }, format: :json }.to_not change(question, :rating)
      end
    end
  end
end