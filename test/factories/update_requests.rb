# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :update_request do
    query 'MyString'
    email 'MyString'
  end
end
