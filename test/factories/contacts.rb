require 'ffaker'

FactoryGirl.define do
  factory :contact do
    name { Faker::NameDE.name }
    email { Faker::Internet.email }
    message 'MyString'
    url 'MyString'

    factory :report do
      email nil
      url 'http://test.host/angebote/foobar'
      reporting true
    end
  end
end
