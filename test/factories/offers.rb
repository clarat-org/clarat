require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    age_from { rand(1..3) }
    age_to { rand(4..6) }
    encounter do
      # weighted
      %w(personal personal personal personal hotline chat forum email online-course).sample
    end
    area { Area.first unless encounter == 'personal' }
    approved_at nil

    # optional fields
    comment { maybe FFaker::Lorem.paragraph(rand(4..6))[0..799] }

    # associations

    transient do
      organization_count 1
      organization nil
      contact_person_count 1
      website_count { rand(0..3) }
      category_count { rand(1..3) }
      category nil # used to get a specific category, instead of category_count
      language_count { rand(1..2) }
      audience_count { rand(1..2) }
      opening_count { rand(1..5) }
      fake_address false
    end

    after :build do |offer, evaluator|
      # organization
      if evaluator.organization
        offer.organizations << evaluator.organization
      else
        evaluator.organization_count.times do
          offer.organizations << FactoryGirl.create(:organization, :approved)
        end
      end
      organization =
        offer.organizations[0] || FactoryGirl.create(:organization, :approved)

      # location
      if offer.personal?
        location =  organization.locations.sample ||
                    if evaluator.fake_address
                      FactoryGirl.create(:location, :fake_address,
                                         organization: organization)
                    else
                      FactoryGirl.create(:location, organization: organization)
                    end
        offer.location = location
      end
      # Filters
      offer.section_filters << (
        SectionFilter.all.sample ||
          FactoryGirl.create(:section_filter)
      )
      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.all.sample ||
            FactoryGirl.create(:language_filter)
        )
      end
      evaluator.audience_count.times do
        offer.target_audience_filters << (
          TargetAudienceFilter.all.sample ||
            FactoryGirl.create(:target_audience_filter)
        )
      end
    end

    after :create do |offer, evaluator|
      # Contact People
      evaluator.organization_count.times do
        offer.contact_people << FactoryGirl.create(
          :contact_person, organization: offer.organizations.first
        )
      end

      # ...
      create_list :hyperlink, evaluator.website_count, linkable: offer
      if evaluator.category
        offer.categories << FactoryGirl.create(:category,
                                               name: evaluator.category)
      else
        evaluator.category_count.times do
          offer.categories << (
            Category.select(:id).all.try(:sample) ||
              FactoryGirl.create(:category)
          )
        end
      end
      evaluator.opening_count.times do
        offer.openings << (
          if Opening.count != 0 && rand(2) == 0
            Opening.select(:id).all.sample
          else
            FactoryGirl.create(:opening)
          end
        )
      end
    end

    trait :approved do
      after :create do |offer, _evaluator|
        Offer.where(id: offer.id).update_all aasm_state: 'approved',
                                             approved_at: Time.zone.now
        offer.reload
      end
      approved_by { FactoryGirl.create(:researcher).id }
    end

    trait :with_email do
      after :create do |offer, _evaluator|
        offer.contact_people.first.update_column(
          :email_id, FactoryGirl.create(:email).id
        )
      end
    end

    trait :with_location do
      encounter 'personal'
    end

    trait :with_creator do
      created_by { FactoryGirl.create(:researcher).id }
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
