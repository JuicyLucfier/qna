require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      it_behaves_like 'API Commentable' do
        let(:commentable) { question }
        let(:commentable_response) { question_response }
      end

      it_behaves_like 'API Attachable' do
        let(:attachable) { question }
        let(:attachable_response) { question_response }
      end

      it_behaves_like 'API Linkable' do
        let(:linkable) { question }
        let(:linkable_response) { question_response }
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question_response) { json['question'] }
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'returns 200 status' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token, headers: headers }

          expect(response).to be_successful
        end

        it 'saves a new question in the database' do
          expect { post api_path, params: { question: attributes_for(:question), access_token: access_token.token,
                                                       headers: headers } }.to change(Question, :count).by(1)
        end

        it 'returns all public fields' do
          post api_path, params: { question: attributes_for(:question), access_token: access_token.token, headers: headers }
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq Question.last.send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post api_path, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 'returns unprocessable entity status' do
          post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token, headers: headers }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'author' do
        let(:question_response) { json['question'] }
        let(:author_access_token) { create(:access_token, resource_owner_id: author.id) }

        context 'with valid attributes' do
          it 'returns 200 status' do
            patch api_path, params: { id: question, question: { body: 'new body' }, access_token: author_access_token.token, headers: headers }

            expect(response).to be_successful
          end

          it 'changes question attributes' do
            patch api_path, params: { id: question, question: { body: 'new body' }, access_token: author_access_token.token, headers: headers }
            question.reload

            expect(question.body).to eq 'new body'
          end

          it 'returns all public fields' do
            patch api_path, params: { id: question, question: { body: 'new body' }, access_token: author_access_token.token, headers: headers }
            question.reload

            %w[id title body created_at updated_at].each do |attr|
              expect(question_response[attr]).to eq question.send(attr).as_json
            end
          end
        end

        context 'with invalid attributes' do
          it 'does not change question attributes' do
            expect do
              patch api_path, params: { id: question, question: attributes_for(:question, :invalid), access_token: author_access_token.token, headers: headers }
              to_not change(question, :body)
            end
          end

          it 'returns unprocessable entity status' do
            patch api_path, params: { id: question, question: attributes_for(:question, :invalid), access_token: author_access_token.token, headers: headers }

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'not author' do
        let(:user) { create(:user) }
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'does not change question attributes' do
          expect do
            patch api_path, params: { id: question, question: { body: 'new body' }, access_token: user_access_token.token, headers: headers }
            to_not change(question, :body)
          end
        end

        it 'returns forbidden status' do
          expect do
            patch api_path, params: { id: question, question: { body: 'new body' }, access_token: user_access_token.token, headers: headers }
            to have_http_status(:forbidden)
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'author' do
        let(:author_access_token) { create(:access_token, resource_owner_id: author.id) }

        it 'returns 200 status' do
          delete api_path, params: { access_token: author_access_token.token, headers: headers }

          expect(response).to be_successful
        end

        it 'deletes the question' do
          expect { delete api_path, params: { access_token: author_access_token.token, headers: headers } }
            .to change(Question, :count).by(-1)
        end
      end

      context 'not author' do
        let(:user) { create(:user) }
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'tries to delete the question' do
          expect { delete api_path, params: { access_token: user_access_token.token, headers: headers } }
            .to_not change(Question, :count)
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
