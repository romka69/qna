require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:questions) { create_list(:question, 2, author: create(:user)) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 2, question: question, author: create(:user)) }

      let(:access_token) { create :access_token }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it_behaves_like 'Request status success'

      it_behaves_like 'Returns list of' do
        let(:json_resource) { json['questions'] }
      end

      it_behaves_like 'Returns fields' do
        let(:fields) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource_name) { question }
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate 7
      end

      describe 'Answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Returns list of' do
          let(:json_resource) { question_response['answers'] }
        end

        it_behaves_like 'Returns fields' do
          let(:fields) { %w[id body question_id created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource_name) { answer }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user,
                             files: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let!(:comment) { create :question_comment, commentable: question, author: user }
    let!(:link) { create :link, linkable: question }

    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:access_token) { create :access_token }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it_behaves_like 'Request status success'

      it_behaves_like 'Returns fields' do
        let(:fields) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource_name) { question }
      end

      describe 'Comments' do
        let(:comment_response) { question_response['comments'].first }

        it 'Returns obj of resource' do
          expect(question_response['comments'].size).to eq 1
        end

        it_behaves_like 'Returns fields' do
          let(:fields) { %w[id body author_id created_at updated_at commentable_type commentable_id] }
          let(:resource_response) { comment_response }
          let(:resource_name) { comment }
        end
      end

      describe 'Links' do
        let(:link_response) { question_response['links'].first }

        it 'Returns obj of resource' do
          expect(question_response['links'].size).to eq 1
        end

        it_behaves_like 'Returns fields' do
          let(:fields) { %w[id name url created_at updated_at linkable_type linkable_id] }
          let(:resource_response) { link_response }
          let(:resource_name) { link }
        end
      end

      describe 'Files' do
        it 'Returns obj of resource' do
          expect(question_response['files'].size).to eq 1
        end

        it 'url in file' do
          expect(question_response['files'].first).to match '/rails_helper.rb'
        end
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:api_path) { "/api/v1/questions" }
    let(:access_token) { create :access_token }

    # second test in shared is fail but work another
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it 'returns 401 status if there is no access_token' do
      post api_path, params: { question: attributes_for(:question) }
      expect(response.status).to eq 401
    end

    # another work
    it 'returns 401 status if access_token is invalid' do
      post api_path, params: { access_token: '12345', question: attributes_for(:question) }
      expect(response.status).to eq 401
    end

    context 'Create question valid attributes' do
      before { post api_path, params: {
          access_token: access_token.token,
          question: attributes_for(:question) } }

      it_behaves_like 'Request status 201'

      it 'add question in db' do
        expect(Question.count).to eq 1
      end

      it 'return fields of new object' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'Create question invalid attributes' do
      before { post api_path, params: {
          access_token: access_token.token,
          question: attributes_for(:question, :invalid) } }

      it 'return 422' do
        expect(response.status).to eq 422
      end

      it 'return error in object' do
        %w[title].each do |attr|
          expect(json.has_key?(attr)).to be_truthy
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create :access_token }

    # second test in shared is fail but work another
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    it 'returns 401 status if there is no access_token' do
      patch api_path, params: { question: attributes_for(:question) }
      expect(response.status).to eq 401
    end

    # another work
    it 'returns 401 status if access_token is invalid' do
      patch api_path, params: { access_token: '12345', question: attributes_for(:question) }
      expect(response.status).to eq 401
    end

    context 'Update question valid attributes' do
      before { patch api_path, params: {
          access_token: access_token.token,
          question: { title: 'Edit title' } } }

      it_behaves_like 'Request status success'

      it 'return fields with modifier data' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'].has_key?(attr)).to be_truthy
        end
      end

      it 'check modifier field' do
        expect(json['question']['title']).to eq 'Edit title'
      end
    end

    context 'Update question invalid attributes' do
      before { patch api_path, params: {
          access_token: access_token.token,
          question: { title: nil } } }

      it 'return 422' do
        expect(response.status).to eq 422
      end

      it 'return error in object' do
        %w[title].each do |attr|
          expect(json.has_key?(attr)).to be_truthy
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }

    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create :access_token }

    # second test in shared is fail but work another
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    it 'returns 401 status if there is no access_token' do
      delete api_path, params: { question: attributes_for(:question) }
      expect(response.status).to eq 401
    end

    # another work
    it 'returns 401 status if access_token is invalid' do
      delete api_path, params: { access_token: '12345', question: attributes_for(:question) }
      expect(response.status).to eq 401
    end

    context 'Authorized' do
      before { delete api_path, params: {
          access_token: access_token.token,
          question: question } }

      it_behaves_like 'Request status success'

      it 'del question in db' do
        expect(Question.count).to eq 0
      end
    end
  end
end
