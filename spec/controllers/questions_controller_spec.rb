require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, author: user) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns a new Link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Link in Question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Badge in Question' do
      expect(assigns(:badge)).to be_a_new(Badge)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saved a new question in the db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'user is author' do
        post :create, params: { question: attributes_for(:question) }

        expect(assigns(:question).author).to eq user
      end

      it 'redirects to show views' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create :user }
    let!(:question) { create :question, author: user1 }

    context 'Author' do
      before { login(user1) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'Not author' do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'return unauthenticated' do
        delete :destroy, params: { id: question }

        expect(response).to have_http_status(403)
      end
    end

    context 'Unauthenticated user' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to login' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    it 'return unauthenticated' do
      patch :update, params: { id: question, question: { title: 'new title', body: 'new body'} }, format: :js

      expect(response).to have_http_status(401)
    end

    context 'With valid attributes' do
      before { login(user) }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update views' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'With invalid attributes' do
      before { login(user) }

      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :title)
      end

      it 'renders update views' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'Not author' do
      let(:user1) { create :user }

      before { login(user1) }

      it 'update the question' do
        expect do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        end.to_not change(question, :title)
      end
    end
  end
end
