require 'ffaker'

FactoryGirl.define do
  factory :assignment do
    message { FFaker::Lorem.sentence }
    creator { User.first }
    creator_team { UserTeam.first }
    receiver { User.last }
    receiver_team { UserTeam.first }
    # translations are the first model for the assignments, so we use them for tests
    assignable { FactoryGirl.create :offer_translation }
    assignable_type 'OfferTranslation'
    parent_id 2

    trait :with_field do
      assignable_field_type 'id' # every model has an ID field
    end
  end
end
