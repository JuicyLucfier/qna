require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:comments) { create_list(:comment, 2, commentable: answer, author: user) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    before {
      answer.files.attach(io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb')
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it "returns files" do
        expect(answer_response['files'].size).to eq answer.send('files').size
      end

      it "returns links" do
        expect(answer_response['links'].size).to eq answer.send('links').size
      end

      describe 'comments' do
        let(:comment) { answer.comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    # let(:api_path) { '/api/v1/questions' }
    #
    # it_behaves_like 'API Authorizable' do
    #   let(:method) { :post }
    # end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'returns 200 status' do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token, headers: headers }

          expect(response).to be_successful
        end

        it 'saves a new answer in the database' do
          expect { post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token, headers: headers } }
            .to change(question.answers, :count).by(1)
        end

        it 'returns all public fields' do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token, headers: headers }

          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq Answer.last.send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token, headers: headers } }
            .to_not change(Answer, :count)
        end

        it 'returns unprocessable entity status' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token, headers: headers }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    # it_behaves_like 'API Authorizable' do
    #   let(:method) { :patch }
    # end

    context 'authorized' do
      context 'author' do
        let(:answer_response) { json['answer'] }
        let(:author_access_token) { create(:access_token, resource_owner_id: author.id) }

        context 'with valid attributes' do
          it 'returns 200 status' do
            patch api_path, params: { answer: { body: 'new body' }, access_token: author_access_token.token, headers: headers }

            expect(response).to be_successful
          end

          it 'changes answer attributes' do
            patch api_path, params: { answer: { body: 'new body' }, access_token: author_access_token.token, headers: headers }
            answer.reload

            expect(answer.body).to eq 'new body'
          end

          it 'returns all public fields' do
            patch api_path, params: { answer: { body: 'new body' }, access_token: author_access_token.token, headers: headers }
            answer.reload

            %w[id body created_at updated_at].each do |attr|
              expect(answer_response[attr]).to eq answer.send(attr).as_json
            end
          end
        end

        context 'with invalid attributes' do
          it 'does not change answer attributes' do
            expect do
              patch api_path, params: { answer: attributes_for(:answer, :invalid), access_token: author_access_token.token, headers: headers }
              to_not change(answer, :body)
            end
          end

          it 'returns unprocessable entity status' do
            patch api_path, params: { answer: attributes_for(:answer, :invalid), access_token: author_access_token.token, headers: headers }

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'not author' do
        let(:user) { create(:user) }
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'does not change answer attributes' do
          expect do
            patch api_path, params: { answer: { body: 'new body' }, access_token: user_access_token.token, headers: headers }
            to_not change(answer, :body)
          end
        end

        it 'returns forbidden status' do
          expect do
            patch api_path, params: { answer: { body: 'new body' }, access_token: user_access_token.token, headers: headers }
            to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let!(:answer) { create(:answer, question: question, author: author) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    # it_behaves_like 'API Authorizable' do
    #   let(:method) { :patch }
    # end

    context 'authorized' do
      context 'author' do
        let(:author_access_token) { create(:access_token, resource_owner_id: author.id) }

        it 'returns 200 status' do
          delete api_path, params: { access_token: author_access_token.token, headers: headers }

          expect(response).to be_successful
        end

        it 'deletes the answer' do
          expect { delete api_path, params: { access_token: author_access_token.token, headers: headers } }
            .to change(Answer, :count).by(-1)
        end
      end

      context 'not author' do
        let(:user) { create(:user) }
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'tries to delete the answer' do
          expect { delete api_path, params: { access_token: user_access_token.token, headers: headers } }
            .to_not change(Answer, :count)
        end

        it 'returns forbidden status' do
          expect do
            delete api_path, params: { access_token: user_access_token.token, headers: headers }
            to have_http_status(:forbidden)
          end
        end
      end
    end
  end
end
