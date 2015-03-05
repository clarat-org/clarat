require 'ffaker'

FactoryGirl.define do
  factory :language_filter do
    name { %w(Deutsch Englisch).sample }
    identifier { name[0..2].downcase }

    # associations
    ignore do
      offer_count 0
    end
    after :create do |language_filter, evaluator|
      create_list :offer, evaluator.offer_count,
                  language_filter: language_filter
    end
  end
end
