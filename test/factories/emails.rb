require 'ffaker'

FactoryGirl.define do
  factory :email do
    address { FFaker::Internet.email }

    trait :with_approved_offer do
      after :create do |email, _evaluator|
        offers = [FactoryGirl.create(:offer, :approved)]
        email.contact_people << FactoryGirl.create(:contact_person,
                                                   offers: offers)
      end
    end

    trait :with_unapproved_offer do
      after :create do |email, _evaluator|
        offers = [FactoryGirl.create(:offer)]
        email.contact_people << FactoryGirl.create(:contact_person,
                                                   offers: offers)
      end
    end

    trait :with_security_code do
      after :build do |email, _evaluator|
        email.send(:regenerate_security_code)
      end
    end

    trait :uninformed do
      aasm_state 'uninformed'
    end

    trait :informed do
      aasm_state 'informed'
    end

    trait :subscribed do
      aasm_state 'subscribed'
    end

    trait :unsubscribed do
      aasm_state 'unsubscribed'
    end
  end
end
