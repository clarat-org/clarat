require 'ffaker'

FactoryGirl.define do
  factory :website do
    sort { Website.enumerized_attributes.attributes['sort'].values.sample }
    url do
      case sort
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
        Faker::Internet.uri(['http', 'https'].sample)
      end
    end
  end
end
