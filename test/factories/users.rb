require 'ffaker'

FactoryGirl.define do
  factory :user do
    name { FFaker::Internet.user_name }
    email { FFaker::Internet.email }
    # password 'password' # not used in front end

    confirmed_at Time.zone.now

    factory :admin, aliases: [:researcher] do
      role 'researcher'
    end

    factory :super do
      role 'super'
    end
  end
end
