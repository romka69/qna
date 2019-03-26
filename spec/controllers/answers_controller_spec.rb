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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'response is 200' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(200)
      end
    end

    context 'Not author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'response is 403' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(403)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'response is 401' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to have_http_status(401)
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

      it 'return unauthenticated' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PATCH #pick_the_best' do
    let(:pick_best) { patch :pick_the_best, params: { id: answer, best: true }, format: :js }

    context 'Unauthenticated user' do
      it 'return unauthenticated' do
        pick_best
        answer.reload

        expect(answer).to_not be_best
      end
    end

    context 'Author of question' do
      before { login(user) }

      it 'pick answer' do
        pick_best
        answer.reload

        expect(answer).to be_best
      end

      it 're-render template pick_the_best' do
        pick_best

        expect(response).to render_template :pick_the_best
      end
    end

    context 'Not author' do
      let(:user1) { create :user }

      before { login(user1) }

      it 'pick best' do
        pick_best
        answer.reload

        expect(answer).to_not be_best
      end

      it 'return unauthenticated' do
        pick_best

        expect(response).to have_http_status(403)
      end
    end
  end

  it_behaves_like 'voted' do
    let(:model) { create :answer, question: question, author: user }
  end
end
