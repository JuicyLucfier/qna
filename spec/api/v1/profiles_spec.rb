require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json'} }
  let(:me) { create(:user) }

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:user_response) { json.first }

      before {
        get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers
      }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users without current user' do
        expect(json.size).to eq 2
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
end
