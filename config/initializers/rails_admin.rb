RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show
  end

  config.model 'Organization' do
    field :name
    field :description do
      css_class "js-count-character"
    end
    field :legal_form
    field :charitable
    field :founded
    field :classification
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end

    field :websites

    show do
      field :offers
    end
  end

  config.label_methods << :url
  # config.model 'Website' do
  #   field :sort
  #   field :url
  # end

  config.model 'Location' do
    field :street
    field :addition
    field :zip
    field :city
    field :telephone
    field :email
    field :hq
    field :organization
    field :federal_state
    field :latitude do
      read_only true
    end
    field :longitude do
      read_only true
    end
    field :websites

    object_label_method :concat_address
  end

  config.model 'FederalState' do
    list do
      field :id do
        sort_reverse false
      end
      field :name
    end
  end

  config.model 'Offer' do
    field :name
    field :description do
      css_class "js-count-character"
    end
    field :todo
    field :telephone
    field :contact_name
    field :email
    field :reach
    field :frequent_changes
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end
    field :location
    field :tags
    field :languages
    field :openings
    field :websites
  end

  config.model 'Opening' do
    field :day
    field :open
    field :close

    object_label_method :concat_day_and_times
  end

  config.model 'Tag' do
    field :name
    field :main
    field :associated_tags

    object_label_method :name_with_optional_asterisk
  end

  config.label_methods << :email
  config.model 'User' do
    field :email
  end

  config.model 'Language' do
    list do
      field :id do
        sort_reverse false
      end
      field :name
      field :code
      field :offers
    end
  end
end
