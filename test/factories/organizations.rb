require 'ffaker'

FactoryGirl.define do
  factory :organization do
    # required
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    legal_form do
      Organization.enumerized_attributes.attributes['legal_form'].values.sample
    end
    charitable { FFaker::Boolean.maybe }

    # optional
    comment { maybe FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    founded { maybe((1980..Time.zone.now.year).to_a.sample) }
    umbrella do
      maybe(
        Organization.enumerized_attributes.attributes['umbrella'].values.sample
      )
    end
    mailings_enabled true
    created_by { FactoryGirl.create(:researcher).id }

    # associations
    transient do
      website_count { rand(0..3) }
      location_count 1
    end

    after :create do |orga, evaluator|
      create_list :hyperlink, evaluator.website_count, linkable: orga
      # Locations
      if evaluator.location_count > 0
        orga.locations << FactoryGirl.create(:location, :hq, organization: orga)
      end
      if evaluator.location_count > 1
        create_list :location, (evaluator.location_count - 1),
                    organization: orga, hq: false
      end
    end

    # traits
    trait :approved do
      after :create do |orga, _evaluator|
        Organization.where(id: orga.id).update_all aasm_state: 'approved',
                                                   approved_at: Time.zone.now
        orga.reload
      end
      approved_by { FactoryGirl.create(:researcher).id }
      approved_at { Time.zone.now }
    end

    trait :mailings_disabled do
      mailings_enabled false
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
