Clarat::Application.routes.draw do
  localized do
    devise_for :users
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    root to: 'pages#home'

    resources :offers, only: [:index, :show]
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
