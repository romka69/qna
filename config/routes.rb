Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :questions, except: %i[edit], concerns: %i[votable commentable], defaults: { commentable: 'question' } do
    resources :answers, shallow: true, except: %i[edit], concerns: %i[votable commentable], defaults: { commentable: 'answer' } do
      patch :pick_the_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :badges, only: %i[index]

  mount ActionCable.server => '/cable'
end
