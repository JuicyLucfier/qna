require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

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

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author_id
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

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:comments) { create_list(:comment, 2, commentable: question, author: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    before {
      question.files.attach(io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb')
    }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it "returns files" do
        expect(question_response['files'].size).to eq question.send('files').size
      end

      it "returns links" do
        expect(question_response['links'].size).to eq question.send('links').size
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author_id
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

      describe 'comments' do
        let(:comment) { question.comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    # let(:api_path) { '/api/v1/questions' }
    #
    # it_behaves_like 'API Authorizable' do
    #   let(:method) { :post }
    # end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:question_response) { json['question'] }
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        it 'returns 200 status' do
          post '/api/v1/questions', params: { question: attributes_for(:question), access_token: access_token.token, headers: headers }

          expect(response).to be_successful
        end

        it 'saves a new question in the database' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:question), access_token: access_token.token,
                                                       headers: headers } }.to change(Question, :count).by(1)
        end

        it 'returns all public fields' do
          post '/api/v1/questions', params: { question: attributes_for(:question), access_token: access_token.token, headers: headers }
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq Question.last.send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post '/api/v1/questions', params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 'returns unprocessable entity status' do
          post '/api/v1/questions', params: { question: attributes_for(:question, :invalid), access_token: access_token.token, headers: headers }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    # it_behaves_like 'API Authorizable' do
    #   let(:method) { :patch }
    # end

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
