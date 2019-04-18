require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }

    it 'return 401 when user not login' do
      post :create, params: { question_id: question.id }, format: :js

      expect(response.status).to eq 401
    end

    context 'Login user' do
      before { login user }

      it 'return 200' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response.status).to eq 200
      end

      it 'subscription save in db' do
        expect do
          post :create, params: { question_id: question.id }, format: :js
        end.to change(Subscription, :count).by 2
      end

      it 'render template' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #destroy' do
    let(:user) { create :user }
    let(:question) { create :question, author: user }
    let!(:subscription) { create :subscription, user: user, question:question }

    it 'return 403 when user not login' do
      delete :destroy, params: { id: subscription }, format: :js

      expect(response.status).to eq 401
    end

    context 'Login user' do
      before { login user }

      it 'unsubscription save in db' do
        expect do
          delete :destroy, params: { id: subscription }, format: :js
        end.to change(Subscription, :count).by -1
      end

      it 'render template' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
