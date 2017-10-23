# frozen_string_literal: true

# Hash that sorts openings, it's possible to have multiple on the same day
class OpeningHash < Hash
  # Initialize a hash that contains each day in order, sort the given offer's
  # openings into the appropriate days
  def initialize offer
    update mon: [], tue: [], wed: [], thu: [], fri: [], sat: [], sun: []

    offer.openings.order('sort_value').find_each do |opening|
      self[opening.day.to_sym] << opening.display_string
    end
  end

  # Iterate over every day that has openings
  def each_open_day
    each do |day, times|
      unless times.empty?
        yield day, times
      end
    end
  end
end
