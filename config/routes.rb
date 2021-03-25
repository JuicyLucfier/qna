Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_for
      patch :vote_against
      patch :vote_cancel
    end
  end

  resources :attachments, only: ['destroy']
  resources :links, only: ['destroy']
  resources :badges, only: ['index']

  resources :questions, concerns: [:voted] do
    resources :answers, concerns: [:voted], shallow: true, only: %i[create update destroy best] do
      member do
        patch 'best', to: 'answers#best'
      end
    end
  end
end
