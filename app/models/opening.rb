class Opening < ActiveRecord::Base
  # associtations
  has_and_belongs_to_many :offers

  # Enumerization
  extend Enumerize
  enumerize :day, in: %w[mon tue wed thu fri sat sun]

  # Validations
  validates :day, presence: true
  validates :open, presence: true
  validates :close, presence: true

  # Methods

  def concat_day_and_times
    if day and open and close
      "#{day.titleize} #{open.strftime('%H:%M')}-#{close.strftime('%H:%M')}"
    end
  end
end
