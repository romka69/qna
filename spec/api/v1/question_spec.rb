require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list(:question, 2, author: create(:user)) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 2, question: question, author: create(:user)) }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it_behaves_like 'Request status'

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

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Returns list of' do
          let(:json_resource) { question_response['answers'] }
        end

        it_behaves_like 'Returns fields' do
          let(:fields) { %w[id body author_id created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource_name) { answer }
        end
      end
    end
  end
end
