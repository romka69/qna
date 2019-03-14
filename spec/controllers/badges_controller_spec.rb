require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  describe 'GET #index' do
    let(:user) { create :user }
    let!(:question) { create :question, author: user }
    let!(:badge) { create :badge, :with_img, question: question, user: user }

    before do
      login(user)
      get :index
    end

    it 'return badge' do
      expect(assigns(:badges)).to eq badge
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end
end
