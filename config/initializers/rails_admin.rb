require Rails.root.join('lib', 'junkdrawer', 'rails_admin_statistics.rb')

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
      except ['Hyperlink', 'FederalState', 'Language']
    end

    ## With an audit adapter, you can add:
    history_index
    history_show
  end

  config.model 'Organization' do
    list do
      field :name
      field :legal_form
      field :completed
      field :approved
      field :creator_email
    end
    weight(-3)
    field :name
    field :description do
      css_class 'js-count-character'
    end
    field :keywords do
      css_class 'js-count-character'
    end
    field :legal_form
    field :charitable
    field :founded
    field :umbrella
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end

    field :websites
    field :completed
    field :approved

    show do
      field :offers
      field :locations
    end
  end

  config.label_methods << :url
  config.model 'Website' do
    field :sort
    field :url
  end

  config.model 'Location' do
    list do
      field :name
      field :organization
      field :zip
      field :federal_state
      field :completed
    end
    weight(-2)
    field :organization
    field :name
    field :street
    field :addition
    field :zip
    field :city
    field :federal_state
    field :telephone
    field :second_telephone
    field :fax
    field :email
    field :hq
    field :latitude do
      read_only true
    end
    field :longitude do
      read_only true
    end
    field :websites
    field :completed

    show do
      field :offers
    end

    object_label_method :concat_address
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
      field :frequent_changes
      field :completed
      field :approved
      field :creator_email
      field :organization
    end
    weight(-1)
    field :name
    field :description do
      css_class 'js-count-character'
    end
    field :keywords do
      css_class 'js-count-character'
    end
    field :next_steps do
      css_class 'js-count-character'
    end
    field :telephone
    field :second_telephone
    field :fax
    field :contact_name
    field :email
    field :encounter
    field :frequent_changes
    field :slug do
      read_only do
        bindings[:object].new_record?
      end
    end
    field :location
    field :organization
    field :tags
    field :languages
    field :openings
    field :opening_specification do
      help do
        'Bitte einigt euch auf eine einheitliche Ausdrucksweise. Wie etwa
        "jeden 1. Montag im Monat" oder "jeden 2. Freitag". Sagt mir
        (Konstantin) auch gern bescheid, wenn ihr ein einheitliches Format
        gefunden habt, mit dem alle Fälle abgedeckt werden können.'
      end
    end
    field :websites
    field :completed
    field :approved
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

  config.model 'Tag' do
    field :name
    field :main
    field :associated_tags

    object_label_method :name_with_optional_asterisk

    list do
      sort_by :name
    end

    show do
      field :offers
    end
  end

  config.model 'Language' do
    weight 1
    list do
      sort_by :name
      field :id
      field :name
      field :code
      field :offers
    end
  end

  config.label_methods << :email
  config.model 'User' do
    weight 1
    edit do
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

  config.model 'Hyperlink' do
    weight 2
  end

  config.model 'SearchLocation' do
    weight 2
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
