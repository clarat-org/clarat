require 'ffaker'

FactoryGirl.define do
  factory :contact do
    name { FFaker::NameDE.name }
    email { FFaker::Internet.email }
    message 'MyString'
    url 'MyString'

    factory :report do
      email nil
      url 'http://test.host/angebote/foobar'
      reporting true
    end
  end
end
