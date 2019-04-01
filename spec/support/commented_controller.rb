RSpec.shared_examples 'commented' do
  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saved a new comment in the db' do
        expect do
          post :create_comment, params: { model: model, commentable: attributes_for(:comment) }, format: :json
        end.to change(Comment, :count).by 1
      end

      it 'user is author' do
        post :create_comment, params: { model: model, commentable: attributes_for(:comment) }, format: :json

        expect(assigns(:model).author).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect do
          post :create_comment, params: { model: model, commentable: attributes_for(:comment, :invalid) }, format: :json
        end.to_not change(Comment, :count)
      end
    end
  end
end
