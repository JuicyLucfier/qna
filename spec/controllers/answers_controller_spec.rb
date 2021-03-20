require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:answer) { create(:answer, question: question, author: author)}

  describe 'POST #create' do
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end
      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: author) }

    context 'author' do
      before { login(author) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            to_not change(answer, :body)
          end
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not author' do
      before { login(user) }

      it "tries to edit other user's answer" do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          to_not change(answer, :body)
        end
      end
    end
  end

  describe 'PATCH #best' do
    context 'author' do
      before { login(author) }

      let!(:answer) { create(:answer, question: question, author: author) }

      context 'answer is not marked as best' do
        it 'marks answer as best' do
          patch :best, params: { id: answer, answer: { best: true } }, format: :js
          answer.reload
          expect(answer.best).to eq true
        end

        it 'redirects to question' do
          patch :best, params: { id: answer, answer: { best: true } }, format: :js
          expect(response).to render_template :best
        end
      end

      context 'answer is marked as best' do
        it 'unmarks answer' do
          expect do
            patch :best, params: { id: answer, answer: { best: false } }, format: :js
            answer.reload
            answer.best.to eq false
          end
        end

        it 'gives badge to author of answer' do
          patch :best, params: { id: answer, answer: { best: false } }, format: :js
          expect(answer.author.badges.last).to eq answer.question.badge
        end

        it 'redirects to question' do
          patch :best, params: { id: answer, answer: { best: false } }, format: :js
          expect(response).to render_template :best
        end
      end
    end

    context 'not author' do
      before { login(user) }
      let!(:answer) { create(:answer, question: question, author: author) }

      it 'tries to change mark of answer' do
        expect { patch :best, params: { id: answer }, format: :js }.to_not change(answer, :best)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: author, question: question) }

    context 'author' do
      before { login(author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      before { login(user) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(answer.files, :count)
      end
    end
  end
end
