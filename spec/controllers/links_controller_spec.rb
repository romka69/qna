require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question, author: user }
  let!(:link) { create :link, linkable: question}

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'response is 200' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status(200)
      end
    end

    context 'Not author' do
      let(:user1) { create :user }

      before { login(user1) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'response is 403' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status(403)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'response is 401' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
