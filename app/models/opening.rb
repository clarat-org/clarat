class Opening < ActiveRecord::Base
  # associtations
  has_and_belongs_to_many :offers

  # Enumerization
  extend Enumerize
  enumerize :day, in: %w[mon tue wed thu fri sat sun]

  # Validations
  validates :day, presence: true, uniqueness: { scope: [:open, :close] }
  validates :open, uniqueness: { scope: [:day, :close] }
  validates_presence_of :open, if: :close
  validates :close, uniqueness: { scope: [:day, :open] }
  validates_presence_of :close, if: :open

  # Methods

  def concat_day_and_times
    if day and open and close
      "#{day.titleize} #{open.strftime('%H:%M')}-#{close.strftime('%H:%M')}"
    end
  end

  # if no times are set the opening is considered "upon appointment"
  def appointment?
    not open and not close
  end
end
