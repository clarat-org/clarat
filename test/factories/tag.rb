# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :tag do
    name_de { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    name_en { name_de + ' (en)' }
    keywords_de { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }

    trait :with_dummy_translations do
      after :create do |tag, _evaluator|
        (I18n.available_locales - [:de]).each do |locale|
          tag["name_#{locale}"] = "#{locale}(#{tag.name_de})"
          tag.save
        end
      end
    end
  end
end
