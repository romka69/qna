Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, except: %i[edit update] do
    resources :answers, shallow: true, except: %i[edit]
  end
end
