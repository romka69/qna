RSpec.shared_examples 'voted' do
  let(:user) { create :user }
  let(:user2) { create :user }

  describe 'POST #vote_up' do
    it 'user can vote' do
      login(user2)

      expect do
        post :vote_up, params: { id: model }, format: :json
      end.to change(Vote, :count).by 1
    end

    it 'author can not self vote' do
      login(model.author)
      post :vote_up, params: { id: model }, format: :json

      expect(response).to have_http_status 403
    end
  end

  describe 'POST #vote_down' do
    it 'user can vote' do
      login(user2)

      expect do
        post :vote_down, params: { id: model }, format: :json
      end.to change(Vote, :count).by 1
    end

    it 'author can not self vote' do
      login(model.author)
      post :vote_down, params: { id: model }, format: :json

      expect(response).to have_http_status 403
    end
  end
end
