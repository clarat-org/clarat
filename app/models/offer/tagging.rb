class Offer
  module Tagging
    extend ActiveSupport::Concern

    included do
      # TODO: maybe #delay this?
      def add_dependent_tags tag
        additional_tags = tag.dependent_tags

        if additional_tags.any?
          current_tags = tags

          additional_tags.each do |atag|
            tags << atag unless current_tags.include? atag
          end
        end
      end
    end
  end
end
