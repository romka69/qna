Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, except: %i[edit], concerns: [:votable] do
    resources :answers, shallow: true, except: %i[edit], concerns: [:votable] do
      patch :pick_the_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :badges, only: %i[index]
end
