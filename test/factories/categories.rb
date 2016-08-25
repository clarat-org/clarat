require 'ffaker'

FactoryGirl.define do
  factory :category do
    name_de { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    name_en { "#{name_de} (en)" }

    after :build do |category|
      # Filters
      category.section_filters << (
        SectionFilter.find_by(name: 'Refugees') || FactoryGirl.create(:section_filter)
      )
    end

    trait :main do
      icon 'a-something'
    end

    trait :with_dummy_translations do
      after :create do |category, _evaluator|
        (I18n.available_locales - [:de]).each do |locale|
          category["name_#{locale}"] = "#{locale}(#{category.name_de})"
          category.save
        end
      end
    end
  end
end
