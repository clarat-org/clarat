Clarat::Application.routes.draw do
  localized do
    devise_for :users
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

    # static pages
    root to: 'pages#home'
    get 'ueber-uns' => 'pages#about', as: 'about'
    get 'haeufige-fragen' => 'pages#faq', as: 'faq'
    get 'impressum' => 'pages#impressum', as: 'impressum'
    get 'rechtliche-hinweise' => 'pages#agb', as: 'agb'
    get 'datenschutzhinweise' => 'pages#privacy', as: 'privacy'
    get '/404' => 'pages#not_found'

    # RESTful resources
    resources :offers, only: [:index, :show]
    resources :organizations, only: [:show]
    # resources :users, only: [:show]
    resources :update_requests, only: [:new, :create]
    resources :search_locations, only: [:show]
    resources :contacts, only: [:new, :create, :index]
    resources :subscriptions, only: [:new, :create]
    resources :definitions, only: [:show]
    get 'categories/:offer_name', controller: :categories, action: :index

    # non-REST routes
    get 'emails/:id/subscribe/:security_code' => 'emails#subscribe',
        as: 'subscribe'
    get 'emails/:id/unsubscribe/:security_code' => 'emails#unsubscribe',
        as: 'unsubscribe'
  end

  # Sidekiq interface
  require 'sidekiq/web'
  require 'sidetiq/web'
  constraint = lambda do |request|
    request.env['warden'].authenticate?
  end
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  # All else => 404
  match '*path', to: 'pages#not_found', via: :all
end
