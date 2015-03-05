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

      algoliasearch index_name: per_env_index,
                    disable_indexing: Rails.env.test?,
                    if: :approved? do
        attributesToIndex %w(
          name description category_string keyword_string organization_name
        )
        ranking %w(
          typo asc(encounter_value) geo words proximity attribute exact custom
        ) # ^encounter_value
        add_attribute :_geoloc, :_tags
        add_attribute :category_string, :keyword_string, :organization_names,
                      :location_street, :location_city, :location_zip,
                      :encounter_value
        attributesForFaceting [:_tags]
        optionalWords STOPWORDS
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
      # TODO: Ueberhaupt notwendig, wenn es für Kategorien keine Synonyme mehr
      # gibt?
      def category_string
        categories.pluck(:name, :synonyms).flatten.compact.uniq.join(', ')
      end

      # additional searchable string made from categories
      def keyword_string
        keywords.pluck(:name, :synonyms).flatten.compact.uniq.join(', ')
      end

      # concatenated organization name for search index
      def organization_names
        organizations.pluck(:name).join(', ')
      end

      # Offer's encounter modifier for indexing
      def encounter_value
        case encounter
        when 'independent' then 0
        when 'determinable', 'fixed' then 1
        end
      end
    end
  end
end
