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
    transient do
      _random do
        [
          %w(children Kinder), %w(parents Eltern),
          %w(nuclear_family Familie), %w(acquaintances Bekannte)
        ].sample
      end
    end
    identifier { _random[0] }
    name { _random[1] }
  end

  factory :section_filter do
    transient do
      _random do
        [%w(family Family), %w(refugees Refugees)].sample
      end
    end
    identifier { _random[0] }
    name { _random[1] }
  end
end
