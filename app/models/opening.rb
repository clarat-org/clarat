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
  validates_presence_of :open, if: :close
  validates :close, uniqueness: { scope: [:day, :open] }
  validates_presence_of :close, if: :open

  validates :sort_value, presence: true
  validates :name, presence: true

  # Callbacks
  before_validation :calculate_sort_value

  before_validation do
    self.name = concat_day_and_times
  end

  # Methods

  # rails_admin can only sort by a single field, that's why we are creating an imaginary time stamp that handles the sorting
  def calculate_sort_value
    return nil unless day
    day_value = DAYS.index(day) + 1
    dummy_time =
      if open && close
        Time.new(1970, 1, day_value, open.hour, open.min,
                 close.hour + close.min / 100.0, 0)
      else
        Time.new(1970, 1, day_value, 0, 0, 0, 0)
      end
    self.sort_value = (dummy_time.to_f * 100).to_i
  end

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
end
