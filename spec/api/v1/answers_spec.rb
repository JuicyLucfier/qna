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
end
