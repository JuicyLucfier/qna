Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_for
      patch :vote_against
      patch :vote_cancel
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]

  resources :questions, concerns: [:voted] do
    resources :comments, only: [:create]

    resources :answers, concerns: [:voted], shallow: true, only: %i[create update destroy best] do
      resources :comments, only: [:create]
      member do
        patch 'best', to: 'answers#best'
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  mount ActionCable.server => '/cable'
end
