class Offer
  module Search
    extend ActiveSupport::Concern

    included do
      include AlgoliaSearch

      def self.per_env_index
        if Rails.env.development?
          "Offer_development_#{ENV['USER']}"
        else
          "Offer_#{Rails.env}"
        end
      end

      def self.personal_index_name
        "#{per_env_index}_personal"
      end

      def self.remote_index_name
        "#{per_env_index}_remote"
      end

      algoliasearch index_name: personal_index_name,
                    disable_indexing: Rails.env.test?,
                    if: :personal_indexable? do
        INDEX = %w(
          name description category_string keyword_string organization_names
          next_steps
        )
        attributesToIndex INDEX
        ranking %w(
          typo geo words proximity attribute exact custom
        )
        ATTRIBUTES = [:category_string, :keyword_string, :organization_names,
                      :organization_display_name, :location_address,
                      :next_steps]
        FACETS = [:_tags, :_age_filters, :_language_filters]
        add_attribute(*ATTRIBUTES)
        add_attribute(*FACETS)
        add_attribute :_geoloc
        attributesForFaceting FACETS
        optionalWords STOPWORDS

        add_index Offer.remote_index_name, disable_indexing: Rails.env.test?,
                                           if: :remote_indexable? do
          attributesToIndex INDEX
          add_attribute(*ATTRIBUTES)
          add_attribute(*FACETS)
          add_attribute :area_minlat, :area_maxlat, :area_minlong, :area_maxlong
          attributesForFaceting FACETS
          optionalWords STOPWORDS

          # no geo necessary
          ranking %w(typo words proximity attribute exact custom)
        end
      end

      def personal_indexable?
        approved? && personal?
      end

      def remote_indexable?
        approved? && !personal?
      end

      def personal?
        encounter == 'personal'
      end

      # Offer's location's geo coordinates for indexing
      def _geoloc
        {
          'lat' => location.try(:latitude) || '0.0',
          'lng' => location.try(:longitude) || '0.0'
        }
      end

      # Offer's categories for indexing
      def _tags
        tags = []
        categories.find_each do |category|
          tags << category.self_and_ancestors.pluck(:name)
        end
        tags.flatten.uniq
      end

      # additional searchable string made from categories
      # TODO: Ueberhaupt notwendig, wenn es fuer Kategorien keine Synonyme mehr
      # gibt?
      def category_string
        categories.pluck(:name).flatten.compact.uniq.join(', ')
      end

      # additional searchable string made from categories
      def keyword_string
        keywords.pluck(:name, :synonyms).flatten.compact.uniq.join(', ')
      end

      # concatenated organization name for search index
      def organization_names
        organizations.pluck(:name).join(', ')
      end

      # filter indexing methods
      %w(age audience language).each do |filter|
        define_method "_#{filter}_filters" do
          send("#{filter}_filters").pluck(:identifier)
        end
      end

      # def _age_filters
      #   age_filters.pluck(:identifier)
      # end
      #
      # def _audience_filters
      #   audience_filters.pluck(:identifier)
      # end
      #
      # def _language_filters
      #   language_filters.pluck(:identifier)
      # end
    end
  end
end
