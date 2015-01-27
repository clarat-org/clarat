require 'ffaker'

FactoryGirl.define do
  factory :update_request do
    search_location 'MyString'
    email { Faker::Internet.email }
  end
end
