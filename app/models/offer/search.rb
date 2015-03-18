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

      def self.local_index_name
        "#{per_env_index}_local"
      end

      def self.national_index_name
        "#{per_env_index}_national"
      end

      algoliasearch index_name: local_index_name,
                    disable_indexing: Rails.env.test?,
                    if: :local_indexable? do
        INDEX = %w(
          name description category_string keyword_string organization_name
        )
        attributesToIndex INDEX
        ranking %w(
          typo asc(encounter_value) geo words proximity attribute exact custom
        )
        ATTRIBUTES = [:category_string, :keyword_string, :organization_names,
                      :location_street, :location_city, :location_zip, :_tags]
        add_attribute(*ATTRIBUTES)
        add_attribute :_geoloc, :encounter_value
        attributesForFaceting [:_tags]
        optionalWords STOPWORDS

        add_index Offer.national_index_name, disable_indexing: Rails.env.test?,
                                             if: :national_indexable? do
          attributesToIndex INDEX
          add_attribute(*ATTRIBUTES)
          attributesForFaceting [:_tags]
          optionalWords STOPWORDS

          # no encounter value
          ranking %w(
            typo geo words proximity attribute exact custom
          )
        end
      end

      def local_indexable?
        approved? && local?
      end

      def national_indexable?
        approved? && !local?
      end

      def local?
        location_id?
      end

      def personal?
        self.encounter_filters.where(identifier: 'personal').count > 0
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

      # Used to differentiate between local "hotlines" and local personal offers
      def encounter_value
        personal? ? 1 : 0
      end
    end
  end
end
