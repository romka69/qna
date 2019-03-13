Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, except: %i[edit] do
      patch :pick_the_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
end
