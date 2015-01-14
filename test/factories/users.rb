require 'ffaker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'

    confirmed_at Time.now

    factory :admin, aliases: [:researcher] do
      role 'researcher'
    end

    factory :super do
      role 'super'
    end
  end
end
