require 'ffaker'

FactoryGirl.define do
  factory :contact_person do
    gender { [:male, :female, nil].sample }
    first_name { FFaker::NameDE.first_name }
    last_name { maybe FFaker::NameDE.last_name }
    area_code_1 { maybe FFaker.numerify('#' * rand(3..6)) }
    local_number_1 { area_code_1 ? FFaker.numerify('#' * rand(7..11)) : nil }
    area_code_2 do
      (rand(2) == 0 && local_number_1) ? FFaker.numerify('#' * rand(3..6)) : nil
    end
    local_number_2 { area_code_2 ? FFaker.numerify('#' * rand(7..11)) : nil }
    fax_area_code { maybe FFaker.numerify('#' * rand(3..6)) }
    fax_number { fax_area_code ? FFaker.numerify('#' * rand(7..11)) : nil }

    organization
    email nil

    transient do
      offers []
    end

    after :create do |contact_person, evaluator|
      if evaluator.offers.any?
        contact_person.offers = evaluator.offers
      end
    end

    trait :no_fields do # careful, makes object invalid
      gender nil
      first_name nil
      last_name nil
      area_code_1 nil
      local_number_1 nil
      area_code_2 nil
      local_number_2 nil
      fax_number nil
      fax_area_code nil
    end

    trait :all_fields do
      with_gender
      with_name
      with_operational_name
      with_telephone
      with_telephone_2
      with_fax
    end

    trait :with_gender do
      gender { %w(male female).sample }
    end

    trait :with_name do
      first_name 'John'
      last_name 'Doe'
    end

    trait :with_operational_name do
      operational_name 'Reception'
    end

    trait :with_telephone do
      area_code_1 '030'
      local_number_1 '123456'
    end

    trait :with_telephone_2 do
      area_code_2 '030'
      local_number_2 '234567'
    end

    trait :with_fax do
      fax_area_code '030'
      fax_number '345678'
    end
  end
end
