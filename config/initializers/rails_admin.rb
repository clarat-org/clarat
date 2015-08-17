RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Auth ==
  # config.authorize_with do |req|
  #   redirect_to main_app.root_path unless current_user.try(:admin?)
  #   if req.action_name == 'statistics' && current_user.role != 'superuser'
  #     redirect_to dashboard_path
  #   end
  # end
  config.authorize_with :cancan
  config.current_user_method &:current_user

  config.excluded_models = ['AgeFilter', 'FederalState',
                            'OrganizationConnection', 'Filter']

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.included_models = %w(
    Organization Website Location FederalState Offer Opening Category Filter
    LanguageFilter AgeFilter User Contact Keyword Definition Note Area Email
    OrganizationConnection SearchLocation ContactPerson Subscription
    UpdateRequest
  )

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ['User', 'FederalState']
    end
    export
    bulk_delete do
      except ['User', 'FederalState']
    end
    show
    edit
    delete do
      except ['User', 'FederalState']
    end
    show_in_app

    clone
    statistics do
      only ['Organization', 'Offer', 'Location']
    end
    # nested_set do
    #   only ['Category']
    # end
    nestable do
      only ['Category']
    end

    ## With an audit adapter, you can add:
    history_index
    history_show
  end

  config.model 'Organization' do
    list do
      field :offers_count
      field :name
      field :renewed
      field :completed
      field :approved
      field :creator
      field :locations_count
      field :created_by

      sort_by :offers_count
    end
    weight(-3)
    field :name
    field :description do
      css_class 'js-count-character'
    end
    field :description_html do
      read_only true
    end
    field :comment do
      css_class 'js-count-character'
    end
    field :legal_form
    field :charitable
    field :accredited_institution
    field :founded
    field :umbrella
    field :parents
    field :children
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end

    field :websites
    field :inform_email_blocked
    field :completed
    field :renewed
    field :approved

    show do
      field :offers
      field :locations
      field :created_by
      field :approved_by
    end

    clone_config do
      custom_method :partial_dup
    end

    export do
      field :id
    end
  end

  config.label_methods << :url
  config.model 'Website' do
    field :host
    field :url

    show do
      field :offers
      field :organizations
    end
  end

  config.label_methods << :display_name
  config.model 'Location' do
    list do
      field :name
      field :organization
      field :zip
      field :federal_state
      field :display_name
    end
    weight(-2)
    field :organization
    field :name
    field :street
    field :addition
    field :zip
    field :city
    field :area_code
    field :local_number
    field :email
    field :federal_state do
      inline_add false
      inline_edit false
    end
    field :hq
    field :latitude do
      read_only true
    end
    field :longitude do
      read_only true
    end
    show do
      field :offers
      field :display_name
    end
    export do
      field :id
    end
    object_label_method :display_name
  end

  config.model 'FederalState' do
    weight 2
    list do
      field :id do
        sort_reverse false
      end
      field :name
    end
  end

  config.model 'Offer' do
    list do
      field :name
      field :location
      field :renewed
      field :completed
      field :approved
      field :creator
      field :expires_at
      field :approved_at
      field :organizations do
        searchable :name
      end
      field :created_by
    end
    weight(-1)
    field :name do
      css_class 'js-category-suggestions__trigger'
    end
    field :description do
      css_class 'js-count-character'
    end
    field :description_html do
      read_only true
    end
    field :comment do
      css_class 'js-count-character'
    end
    field :next_steps do
      css_class 'js-count-character'
    end
    field :next_steps_html do
      read_only true
    end
    field :legal_information
    field :contact_people
    field :encounter
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end
    field :location
    field :area
    field :organizations do
      help do
        'Required before approval. Only approved organizations.'
      end
    end
    field :categories do
      css_class 'js-category-suggestions'
    end
    field :language_filters
    field :target_gender
    field :target_audience do
      help do
        'Richtet sich das Angebot direkt an das Kind, oder an Erwachsene wie
        z.B. die Eltern, einen Nachbarn oder einen Lotsen'
      end
    end
    field :age_from
    field :age_to
    field :openings
    field :opening_specification do
      help do
        'Bitte einigt euch auf eine einheitliche Ausdrucksweise. Wie etwa
        "jeden 1. Montag im Monat" oder "jeden 2. Freitag". Sagt mir
        (Konstantin) auch gern bescheid, wenn ihr ein einheitliches Format
        gefunden habt, mit dem alle Fälle abgedeckt werden können.'
      end
    end
    field :opening_specification_html do
      read_only true
    end
    field :websites
    field :keywords do
      inverse_of :offers
    end
    field :expires_at
    field :completed
    field :approved
    field :unapproved_reason
    field :renewed
    # Nested Fields
    field :notes

    show do
      field :created_at do
        strftime_format "%d. %B %Y"
      end
      field :created_by
      field :approved_by
    end

    statistics do
    end

    clone_config do
      custom_method :partial_dup
    end

    export do
      field :id
    end
  end

  config.model 'ContactPerson' do
    object_label_method :display_name
    list do
      field :id
      field :first_name
      field :last_name
      field :organization
      field :offers
      field :email_address
    end
    field :gender
    field :academic_title
    field :first_name
    field :last_name
    field :operational_name do
      help do
        "Falls es sich nicht um einen persönlichen Ansprechpartner handelt hier
        z.B. 'Zentrale' eintragen"
      end
    end
    field :role do
      help do
        "Z.b. 'Geschäftsführer'"
      end
    end
    field :responsibility do
      help do
        "Z.b. 'Zuständig für alle Anfragen von Menschen deren Nachname mit den
        Buchstaben A-M anfangen'"
      end
    end
    field :area_code_1
    field :local_number_1
    field :area_code_2
    field :local_number_2
    field :fax_area_code
    field :fax_number
    field :email
    field :organization
    field :offers
    export do
      field :id
    end
    clone_config do
      custom_method :partial_dup
    end

    show do
      field :referencing_notes
    end
  end

  config.model 'Opening' do
    field :day do
      help do
        'Required. Wenn weder "Open" noch "Close" angegeben werden, bedeutet
        das an diesem Tag "nach Absprache".'
      end
    end
    field :open do
      help do
        'Required if "Close" given.'
      end
    end
    field :close do
      help do
        'Required if "Open" given.'
      end
    end

    field :name do
      visible false
    end

    list do
      sort_by :sort_value
      field :sort_value do
        sort_reverse false
        visible false
      end
    end
  end

  config.model 'Category' do
    field :name
    field :parent
    field :sort_order

    object_label_method :name_with_optional_asterisk

    list do
      sort_by :name
    end

    show do
      field :offers
      field :icon
    end

    # nested_set(max_depth: 5)
    nestable_tree(max_depth: 5)
  end

  config.model 'Definition' do
    field :key
    field :explanation

    object_label_method :key
  end

  config.model 'Email' do
    field :address
    field :aasm_state do
      read_only true
    end

    object_label_method :address
  end

  config.model 'Note' do
    list do
      field :text
      field :topic
      field :user
      field :closed
      field :created_at
      field :notable
      field :referencable
    end

    edit do
      field :notable
      field :text
      field :topic
      field :referencable

      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end

    nested do
      field :notable do
        visible false
      end
    end

    update do
      field :id do
        read_only true
      end
      field :text do
        read_only true
      end
      field :topic do
        read_only true
      end
      field :user do
        read_only true
      end
      field :notable do
        read_only true
      end
      field :user_id do
        read_only true
        visible false
      end

      field :referencable
      field :closed
    end
  end

  config.model 'Filter' do
    weight 1
    list do
      field :id
      field :name
      field :identifier
      field :offers
    end
  end
  config.model 'LanguageFilter' do
    parent Filter
  end
  config.model 'AgeFilter' do
    parent Filter
  end

  config.model 'User' do
    weight 1
    list do
      field :id
      field :name
      field :email
      field :role
      field :created_at
      field :updated_at
    end

    edit do
      field :name do
        read_only do
          bindings[:object] != bindings[:view].current_user
        end
      end
      field :email do
        read_only do
          bindings[:object] != bindings[:view].current_user
        end
      end
      field :password do
        visible do
          bindings[:object] == bindings[:view].current_user
        end
      end
    end
  end

  config.model 'Keyword' do
    weight 1
  end

  config.model 'Area' do
    weight 1
  end

  config.model 'Contact' do
    weight 2
  end

  config.model 'Subscription' do
    weight 2
  end

  config.model 'UpdateRequest' do
    weight 2
  end

  config.model 'ContactPersonOffer' do
    weight 3
  end

  config.model 'OrganizationConnection' do
    weight 3
  end

  config.model 'SearchLocation' do
    weight 3
    field :query do
      read_only true
    end
    field :latitude do
      read_only true
    end
    field :longitude do
      read_only true
    end
  end
end
