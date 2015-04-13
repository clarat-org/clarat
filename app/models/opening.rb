# Opening Times of Offers
class Opening < ActiveRecord::Base
  # associtations
  has_and_belongs_to_many :offers

  # Enumerization
  extend Enumerize
  DAYS = %w(mon tue wed thu fri sat sun)
  enumerize :day, in: DAYS

  # Validations
  validates :day, presence: true, uniqueness: { scope: [:open, :close] }
  validates :open, uniqueness: { scope: [:day, :close] }
  validates :open, presence: true, if: :close
  validates :close, uniqueness: { scope: [:day, :open] }
  validates :close, presence: true, if: :open

  validates :sort_value, presence: true
  validates :name, presence: true

  # Callbacks
  before_validation :calculate_sort_value

  before_validation do
    self.name = concat_day_and_times
  end

  # Methods

  def concat_day_and_times
    if day && open && close
      "#{day.titleize} #{open.strftime('%H:%M')}-#{close.strftime('%H:%M')}"
    elsif day
      "#{day.titleize} (appointment)"
    end
  end

  # if no times are set the opening is considered "upon appointment"
  def appointment?
    !open && !close
  end

  def display_string
    "#{open.strftime('%k:%M')} Uhr - #{close.strftime('%k:%M')} Uhr"
  end

  # rails_admin can only sort by a single field, that's why we are creating an
  # imaginary time stamp that handles the sorting
  def calculate_sort_value
    return nil unless day
    dummy_time = dummy_time_for_day DAYS.index(day) + 1
    self.sort_value = (dummy_time.to_f * 100).to_i
  end

  private

  # generate imaginary timestamp for a specific day
  def dummy_time_for_day day_nr
    if open && close
      Time.new(1970, 1, day_nr, open.hour, open.min,
               close.hour + close.min / 100.0, 0)
    else
      Time.new(1970, 1, day_nr, 0, 0, 0, 0)
    end
  end
end
