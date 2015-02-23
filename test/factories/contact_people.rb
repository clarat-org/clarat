require 'ffaker'

FactoryGirl.define do
  factory :contact_person do
    name { Faker::NameDE.name }
    telephone { maybe Faker.numerify('#' * rand(7..11)) }
    second_telephone { (rand(2) == 0 && telephone) ? Faker.numerify('#' * rand(7..11)) : nil }
    email { maybe Faker::Internet.email }

    organization

    trait :no_fields do # careful, makes object non-valid
      name nil
      telephone nil
      second_telephone nil
      email nil
    end
  end
end
