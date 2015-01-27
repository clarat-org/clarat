Clarat::Application.routes.draw do
  localized do
    devise_for :users
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    # static pages
    root to: 'pages#home'
    get 'ueber-uns' => 'pages#about'
    get 'haeufige-fragen' => 'pages#faq'
    get 'impressum' => 'pages#impressum'
    get 'rechtliche-hinweise' => 'pages#agb'
    get 'datenschutzerklaerung' => 'pages#privacy'

    # RESTful resources
    resources :offers, only: [:index, :show]
    resources :organizations, only: [:show]
    # resources :users, only: [:show]
    resources :update_requests, only: [:new, :create]
    resources :search_locations, only: [:show]
    resources :contacts, only: [:new, :create, :index]
    resources :subscriptions, only: [:new, :create]
    get 'tags/:offer_name', controller: :tags, action: :index
  end

  # Sidekiq interface
  require 'sidekiq/web'
  constraint = lambda do |request|
    request.env['warden'].authenticate? && request.env['warden'].user.admin?
  end
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end
end
