Rails.application.routes.draw do
  devise_for :users, controllers: {
    invitations: 'backend/invitations', registrations: 'registrations'
  }

  namespace :backend do
    resources :users, only: [:index, :destroy] do
      member do
        get :confirm_destroy
        get :reinvite
      end
    end
  end

  resource :profile, only: [:show, :edit, :update, :destroy] do
    get :confirm_destroy
  end

  require 'sidekiq/web'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
  #authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/backend/jobs'
  #end

  root to: "welcome#index"

  get 'style-guide', to: 'style_guide#index'
end
