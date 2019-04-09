require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:me) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: me.id }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it_behaves_like 'Request status'

      it_behaves_like 'Returns fields' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource_name) { me }
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:access_token) { create :access_token }
      let!(:users) { create_list :user, 2 }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request status'

      it_behaves_like 'Returns list of' do
        let(:json_resource) { json['users'] }
      end

      it_behaves_like 'Returns fields' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { user_response }
        let(:resource_name) { user }
      end
    end
  end
end
