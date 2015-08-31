require 'ffaker'

FactoryGirl.define do
  factory :language_filter do
    name { %w(Deutsch Englisch).sample }
    identifier { name[0..2].downcase }

    # associations
    transient do
      offer_count 0
    end
    after :create do |language_filter, evaluator|
      create_list :offer, evaluator.offer_count,
                  language_filter: language_filter
    end
  end

  factory :target_audience_filter do
    name { %w(Kinder Eltern Familie Bekannte).sample }
    identifier { %w(children parents family aquintances).sample }

    # # associations
    # transient do
    #   offer_count 0
    # end
    # after :create do |target_audience_filter, evaluator|
    #   create_list :offer, evaluator.offer_count,
    #               target_audience_filter: target_audience_filter
    # end
  end
end
