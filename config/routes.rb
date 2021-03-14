Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: ['destroy']

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy best] do
      member do
        patch 'best', to: 'answers#best'
      end
    end
  end
end
