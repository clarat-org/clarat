class TurnLanguageIntoFilter < ActiveRecord::Migration
  class Language < ActiveRecord::Base
  end
  class Filter < ActiveRecord::Base
  end

  def up
    add_column :languages, :type, :string

    Language.find_each do |language|
      language.update_column :type, 'LanguageFilter'
    end

    change_column :languages, :type, :string, null: false
    change_column :languages, :code, :string, limit: 20, null: false
    rename_column :languages, :code, :identifier

    rename_table :languages, :filters
    rename_table :languages_offers, :filters_offers
    rename_column :filters_offers, :language_id, :filter_id
  end

  def down
    Filter.where.not(type: 'LanguageFilter').destroy_all

    rename_column :filters_offers, :filter_id, :language_id
    rename_table :filters_offers, :languages_offers
    rename_table :filters, :languages

    change_column :languages, :code, :string, limit: 3, null: false

    remove_column :languages, :type
  end
end
