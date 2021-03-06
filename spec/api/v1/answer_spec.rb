require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:answers) { create_list(:answer, 2, question: question, author: user) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      let(:access_token) { create :access_token }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it_behaves_like 'Request status success'

      it_behaves_like 'Returns list of' do
        let(:json_resource) { json['answers'] }
      end

      it_behaves_like 'Returns fields' do
        let(:fields) { %w[id body question_id created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource_name) { answer }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }
    let!(:answer) { create :answer, question: question, author: user,
                           files: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let!(:comment) { create :answer_comment, commentable: answer, author: user }
    let!(:link) { create :link, linkable: answer }

    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:access_token) { create :access_token }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it_behaves_like 'Request status success'

      it_behaves_like 'Returns fields' do
        let(:fields) { %w[id body question_id created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource_name) { answer }
      end

      describe 'Comments' do
        let(:comment_response) { answer_response['comments'].first }

        it 'Returns obj of resource' do
          expect(answer_response['comments'].size).to eq 1
        end

        it_behaves_like 'Returns fields' do
          let(:fields) { %w[id body author_id created_at updated_at commentable_type commentable_id] }
          let(:resource_response) { comment_response }
          let(:resource_name) { comment }
        end
      end

      describe 'Links' do
        let(:link_response) { answer_response['links'].first }

        it 'Returns obj of resource' do
          expect(answer_response['links'].size).to eq 1
        end

        it_behaves_like 'Returns fields' do
          let(:fields) { %w[id name url created_at updated_at linkable_type linkable_id] }
          let(:resource_response) { link_response }
          let(:resource_name) { link }
        end
      end

      describe 'Files' do
        it 'Returns obj of resource' do
          expect(answer_response['files'].size).to eq 1
        end

        it 'url in file' do
          expect(answer_response['files'].first).to match '/rails_helper.rb'
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create :access_token }
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'Create answer valid attributes' do
      before { post api_path, params: {
          access_token: access_token.token,
          answer: { body: 'body', question: question } }, headers: headers }

      it_behaves_like 'Request status 201'

      it 'add answer in db' do
        expect(Answer.count).to eq 1
      end

      it 'return fields of new object' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'Create answer invalid attributes' do
      before { post api_path, params: {
          access_token: access_token.token,
          answer: { body: nil, question: question } }, headers: headers }

      it 'return 422' do
        expect(response.status).to eq 422
      end

      it 'return error in object' do
        %w[body].each do |attr|
          expect(json.has_key?(attr)).to be_truthy
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let(:answer) { create :answer, question: question, author: user}

    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create :access_token }
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'Update question valid attributes' do
      before { patch api_path, params: {
          access_token: access_token.token,
          answer: { body: 'Edit body' } }, headers: headers }

      it_behaves_like 'Request status success'

      it 'return fields with modifier data' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end

      it 'check modifier field' do
        expect(json['answer']['body']).to eq 'Edit body'
      end
    end

    context 'Update question invalid attributes' do
      before { patch api_path, params: {
          access_token: access_token.token,
          answer: { body: nil } }, headers: headers }

      it 'return 422' do
        expect(response.status).to eq 422
      end

      it 'return error in object' do
        %w[body].each do |attr|
          expect(json.has_key?(attr)).to be_truthy
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let!(:answer) { create :answer, question: question, author: user}

    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create :access_token }
    let(:headers) { { "ACCEPT" => "application/json" } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'Authorized' do
      before { delete api_path, params: {
          access_token: access_token.token,
          answer: answer }, headers: headers }

      it_behaves_like 'Request status success'

      it 'del answer in db' do
        expect(Answer.count).to eq 0
      end
    end
  end
end
