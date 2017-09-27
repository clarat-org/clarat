# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    old_next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    encounter do
      # weighted
      %w[personal personal personal personal hotline chat forum email online-course portal].sample
    end
    area { Area.first }
    approved_at nil
    location { Location.last || FactoryGirl.create(:location) }
    solution_category { SolutionCategory.last || FactoryGirl.create(:solution_category) }

    # associations

    transient do
      website_count { rand(0..3) }
      category_count { rand(1..3) }
      category nil # used to get a specific category, instead of category_count
      language_count { rand(1..2) }
      audience_count 1
      opening_count { rand(1..5) }
      fake_address false
    end

    after :build do |offer, evaluator|
      # SplitBase => Division(s) => Organization(s)
      offer.split_base = FactoryGirl.create(:split_base)
      organization = offer.organizations[0]
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
      offer.section = (
        Section.all.sample ||
          FactoryGirl.create(:section)
      )

      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.all.sample ||
            FactoryGirl.create(:language_filter)
        )
      end
    end

    after :create do |offer, evaluator|
      # Contact People
      offer.organizations.count.times do
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
          # Category.select(:id).all.try(:sample) ||
          offer.categories <<
            FactoryGirl.create(:category, sections: [offer.section])
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
      evaluator.audience_count.times do
        offer.target_audience_filters << (
          TargetAudienceFilter.all.sample ||
            FactoryGirl.create(:target_audience_filter)
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

    trait :family_section do
      after :create do |offer, _evaluator|
        offer.section = Section.where(identifier: 'family').last
        offer.save
      end
    end

    trait :refugee_section do
      after :create do |offer, _evaluator|
        offer.section = Section.where(identifier: 'refugees').last
        offer.save
      end
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

    trait :with_dummy_translations do
      after :create do |offer, _evaluator|
        (I18n.available_locales - [:de]).each do |locale|
          OfferTranslation.create(
            offer_id: offer.id, locale: locale, source: 'GoogleTranslate',
            name: "#{locale}(#{offer.name})",
            description: "#{locale}(#{offer.description})",
            old_next_steps: "GET READY FOR CANADA! (#{locale})",
            opening_specification: offer.opening_specification ? locale : nil
          )

          offer.organizations.each do |organization|
            OrganizationTranslation.create(
              organization_id: organization.id, locale: locale,
              source: 'GoogleTranslate',
              description: "#{locale}(#{organization.description})"
            )
          end
        end
      end
    end

    trait :with_markdown do
      after :create do |offer, _evaluator|
        offer.update_column :description, MarkdownRenderer.render(
          offer.description
        )
        offer.update_column :old_next_steps, MarkdownRenderer.render(
          offer.old_next_steps
        )
      end
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
