require 'ffaker'

FactoryGirl.define do
  factory :website do
    host { Website.enumerized_attributes.attributes['host'].values.sample }
    sequence(:url) do |n|
      case host
      when 'facebook'
        "https://www.facebook.com/#{FFaker::Internet.domain_word}#{n}"
      when 'twitter'
        "https://www.twitter.com/#{FFaker::Internet.domain_word}#{n}"
      when 'youtube'
        "https://www.youtube.com/channel/#{FFaker::Internet.domain_word}#{n}"
      when 'gplus'
        "https://plus.google.com/#{FFaker::Internet.domain_word}#{n}"
      when 'pinterest'
        "https://www.pinterest.com/#{FFaker::Internet.domain_word}#{n}"
      else # when 'own', 'document', 'other'
        FFaker::Internet.uri(%w(http https).sample) + n.to_s
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
      url 'http://www.example.com/'
    end

    trait :pdf do
      host 'document'
      url 'http://www.t.com/t.pdf'
    end
  end
end
