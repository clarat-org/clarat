class Offer
  module Search
    extend ActiveSupport::Concern

    included do
      include AlgoliaSearch
      algoliasearch per_environment: true,
                    disable_indexing: Rails.env.test?,
                    if: :approved? do
        attributesToIndex %w(
          name description keyword_string organization_name
        )
        ranking %w(
          typo asc(encounter_value) geo words proximity attribute exact custom
        ) # ^encounter_value
        add_attribute :_geoloc, :_tags
        add_attribute :keyword_string, :organization_names, :location_street,
                      :location_city, :location_zip, :encounter_value
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

      # Offer's tags for indexing
      def _tags
        tags.pluck(:name)
      end

      # additional searchable string made from tags
      def keyword_string
        tags.pluck(:name, :synonyms).flatten.compact.uniq.join(', ')
      end

      # concatenated organization name for search index
      def organization_names
        organizations.pluck(:name).join(', ')
      end
    end
  end
end
