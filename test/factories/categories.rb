require 'ffaker'

FactoryGirl.define do
  factory :category do
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }

    after :build do |category|
      # Filters
      category.section_filters << (
        SectionFilter.first || FactoryGirl.create(:section_filter)
      )
    end

    trait :main do
      icon 'a-something'
    end

    trait :with_dummy_translations do
      after :create do |category, _evaluator|
        (I18n.available_locales - [:de]).each do |locale|
          CategoryTranslation.create(
            category_id: category.id, locale: locale, source: 'GoogleTranslate',
            name: "#{locale}(#{category.untranslated_name})"
          )
        end
      end
    end
  end
end
