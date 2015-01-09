require 'ffaker'

FactoryGirl.define do
  factory :website do
    host { Website.enumerized_attributes.attributes['host'].values.sample }
    url do
      case host
      when 'facebook'
        "https://www.facebook.com/#{Faker::Internet.domain_word}"
      when 'twitter'
        "https://www.twitter.com/#{Faker::Internet.domain_word}"
      when 'youtube'
        "https://www.youtube.com/channel/#{Faker::Internet.domain_word}"
      when 'gplus'
        "https://plus.google.com/#{Faker::Internet.domain_word}"
      when 'pinterest'
        "https://www.pinterest.com/#{Faker::Internet.domain_word}"
      else # when 'own', 'other'
        Faker::Internet.uri(%w(http https).sample)
      end
    end

    trait :social do
      host do
        hosts = Website.enumerized_attributes.attributes['host'].values
        (hosts - %w(own other)).sample
      end
    end

    trait :own do
      host 'own'
    end
  end
end
