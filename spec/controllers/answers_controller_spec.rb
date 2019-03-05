require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }
  let(:answer) { create :answer, question: question, author: user }


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saved a new answer in the db' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'user is author' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(assigns(:answer).author).to eq user
      end

      it 'redirects to create views' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders create view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:answer) { create :answer, question: question, author: user1 }

    context 'Author' do
      before { login(user1) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question#show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Not author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to question#show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to login' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    it 'return unauthenticated' do
      patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

      expect(response).to have_http_status(401)
    end

    context 'With valid attributes' do
      before { login(user) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'renders update views' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'With invalid attributes' do
      before { login(user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update views' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'Not author' do
      let(:user1) { create :user }

      before { login(user1) }

      it 'update the answer' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end
end
