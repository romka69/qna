Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, only: %i[index new create show] do
    resources :answers, shallow: true, only: %i[new create show]
  end
end
