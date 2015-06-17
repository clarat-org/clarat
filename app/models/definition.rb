# Internal dictionary: Definitions for certain words get automatically
# infused into the texts of other models.
class Definition < ActiveRecord::Base
  # Validations
  validates :key, presence: true, uniqueness: true, length: { maximum: 50 },
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
      definition.keys.each do |key|
        regex = /\b(#{key})\b/i
        next unless string.match regex

        # insert the definition markup around a found definition key.
        string.gsub! regex,
                     "<dfn class='JS-tooltip' data-id='#{definition.id}'>"\
                     '\1</dfn>'

        # a string may only provide definitions for one key in the set
        break
      end
    end
    string
  end
end
