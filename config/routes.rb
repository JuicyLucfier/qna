Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    member do
      delete 'delete_attachment', to: 'questions#delete_attachment'
    end

    resources :answers, shallow: true, only: %i[create update destroy best] do

      member do
        patch 'best', to: 'answers#best'
        delete 'delete_attachment', to: 'answers#delete_attachment'
      end
    end
  end
end
