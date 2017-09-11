# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contact_person_offer do
    offer
    contact_person
  end
end
