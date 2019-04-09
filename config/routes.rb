Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resource :comments, only: %i[create]
  end

  resources :questions, except: %i[edit], concerns: %i[votable commentable] do
    resources :answers, shallow: true, except: %i[edit], concerns: %i[votable commentable] do
      patch :pick_the_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :badges, only: %i[index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index]
    end
  end

  mount ActionCable.server => '/cable'
end
