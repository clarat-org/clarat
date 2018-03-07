# frozen_string_literal: true

Clarat::Application.routes.draw do
  # Sitemap path
  mount DynamicSitemaps::Engine => '/sitemaps/'

  localized do
    # unscoped static pages
    # root to: 'pages#section_forward'
    get '/404' => 'pages#not_found'

    root to: 'pages#section_choice', as: 'section_choice'

    scope ':section', section: /refugees/ do
      # scoped static pages
      get '/', to: redirect('https://local.handbookgermany.de/', status: 301)
      get 'ueber-uns', to: redirect('https://handbookgermany.de/de/about-us.html', status: 301)
      get 'haeufige-fragen', to: redirect('https://handbookgermany.de/de/about-us/faq.html', status: 301)
      get 'impressum', to: redirect('https://handbookgermany.de/de/imprint.html', status: 301)
      get 'rechtliche-hinweise', to: redirect('https://handbookgermany.de/de/disclaimer.html', status: 301)
      get 'datenschutzhinweise', to: redirect('https://handbookgermany.de/de/privacy.html', status: 301)

      # RESTful resources
      get 'offers/:id', to: redirect('https://local.handbookgermany.de/angebote/%{id}', status: 301)
      get 'offers', to: redirect('https://local.handbookgermany.de/angebote', status: 301)
      get 'organizations/:id', to: redirect('https://local.handbookgermany.de/organisationen/%{id}', status: 301)
      # resources :organizations, only: [:show]
      # resources :contacts, only: %i[new create index]

      # Previews
      # get 'preview/offers/:id' => 'previews#show_offer'
      # get 'preview/organizations/:id' => 'previews#show_organization'

      # Email overviews
      # get 'emails/:id/offers' => 'emails#offers_index', as: 'emails_offers'
    end

    # scope 'refugees' do
    #   get 'widget-start-with-a-friend' => 'pages#widget_swaf', as: 'home'
    #   get 'widget-handbook-germany-:city' => 'pages#widget_hg', as: 'home'
    # end

    # unscoped to scoped forwards
    get 'offers/:id' => 'offers#section_forward', as: :unscoped_offer
    get 'organizations/:id' => 'organizations#section_forward',
        as: :unscoped_orga
    get 'ueber-uns' => 'pages#section_forward'
    get 'haeufige-fragen' => 'pages#section_forward'
    get 'impressum' => 'pages#section_forward'
    get 'rechtliche-hinweise' => 'pages#section_forward'
    get 'datenschutzhinweise' => 'pages#section_forward'

    # unscoped RESTful resources (only POST and non-HTML GET)
    # resources :update_requests, only: %i[new create]
    # resources :search_locations, only: [:show]
    # resources :subscriptions, only: %i[new create]
    # resources :definitions, only: [:show]

    # non-REST routes
    # get 'emails/:id/subscribe/:security_code' => 'emails#subscribe',
    #     as: 'subscribe'
    # get 'emails/:id/unsubscribe/:security_code' => 'emails#unsubscribe',
    #     as: 'unsubscribe'

    # forward everything with /family to Elternleben
    match '/family(/*path)', to: redirect('https://www.elternleben.de/angebote-vor-ort/', status: 301), via: :all

    # forward unscoped offer index to HBG after generic /family redirect
    get 'offers', to: redirect('https://local.handbookgermany.de/angebote', status: 301)

    # All other localized paths => localized 404
    match '*path', to: 'pages#not_found', via: :all
  end

  # Unlocalized unknown paths are forwarded to the German 404
  match '*path', to: 'pages#not_found', via: :all
end
