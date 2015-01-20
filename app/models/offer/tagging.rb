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

      # after save, works for rails_admin but maybe not in all future cases
      # REFACTOR if possible, although I don't see a way at the moment
      def prevent_duplicate_tags
        tag_array = self.tags.to_a
        dupes = tag_array.select { |tag| tag_array.count(tag) > 1 }.uniq
        dupes.each do |dupe|
          self.tags.destroy(dupe) # destroy all (in case there are more than 2)
          self.tags << dupe # create it exactly once again
        end
      end
    end
  end
end
