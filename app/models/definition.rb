# Internal dictionary: Definitions for certain words get automatically
# infused into the texts of other models.
class Definition < ActiveRecord::Base
  # Validations
  validates :key, presence: true, uniqueness: true,
                  exclusion: { in: %w(dfn class JS tooltip) }
  validates :explanation, presence: true, length: { maximum: 500 }

  # Methods

  # A definition can have multiple comma seperated keys. This method returns all
  # keys in an array.
  def keys
    key.split(',').map(&:strip)
  end

  # Infuses from the list of all definitions into the given string
  def self.infuse string
    # check string for every definition in the DB
    select(:id, :key).find_each do |definition|
      # go through the set of keys for this definition
      a = []
      definition.keys.each do |key|
        a << [string.index(key), key] if string.index(key)
      end

      # find the key that occurs first in the description
      first_key = a.sort[0][1]
      if first_key
        regex = /\b(#{first_key})\b/i
        string.sub! regex,
                      "<dfn class='JS-tooltip' data-id='#{definition.id}'>"\
                      '\1</dfn>'
      end
    end
    string
  end
end
