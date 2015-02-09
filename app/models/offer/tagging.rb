class Offer
  module Tagging
    extend ActiveSupport::Concern

    included do
      # TODO: maybe #delay this?
      def add_dependent_categories cat
        additional_categories = cat.dependent_categories

        if additional_categories.any?
          current_categories = categories

          additional_categories.each do |acat|
            categories << acat unless current_categories.include? acat
          end
        end
      end

      # after save, works for rails_admin but maybe not in all future cases
      # REFACTOR if possible, although I don't see a way at the moment
      def prevent_duplicate_categories
        cat_array = self.categories.to_a
        dupes = cat_array.select { |cat| cat_array.count(cat) > 1 }.uniq
        dupes.each do |dupe|
          # destroy all (in case there are more than 2)
          self.categories.destroy(dupe)
          # create it exactly once again
          self.categories << dupe
        end
      end
    end
  end
end
