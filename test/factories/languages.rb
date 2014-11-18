require 'ffaker'

FactoryGirl.define do
  factory :language do
    name { ['Deutsch', 'Englisch'].sample }
    code { name[0..2].downcase }

    # associations
    ignore do
      offer_count 0
    end
    after :create do |language, evaluator|
      create_list :offer, evaluator.offer_count, language: language
    end
  end
end
