# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    old_next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    encounter do
      # weighted
      %w[personal personal personal personal
         hotline chat forum email online-course portal].sample
    end
    area { Area.first }
    approved_at nil
    location { Location.last || FactoryBot.create(:location) }
    solution_category do
      SolutionCategory.last ||
        FactoryBot.create(:solution_category)
    end
    # every offer should have a creator!
    created_by { User.all.sample.id || FactoryBot.create(:researcher).id }

    # associations
    transient do
      website_count { rand(0..3) }
      tag_count { rand(1..3) }
      language_count { rand(1..2) }
      audience_count 1
      divisions nil
      opening_count { rand(1..5) }
      fake_address false
      section nil
      organizations nil
    end

    after :build do |offer, evaluator|
      organizations = evaluator.organizations ||
                      [FactoryBot.create(:organization, :approved)]
      organization = organizations.first
      div = organization.divisions.first ||
            FactoryBot.create(:division, organization: organization)
      offer.divisions << div
      # location
      if offer.personal?
        location = organization.locations.sample ||
                   if evaluator.fake_address
                     FactoryBot.create(:location, :fake_address,
                                       organization: organization)
                   else
                     FactoryBot.create(:location, organization: organization)
                   end
        offer.location = location
      end

      # Filters
      if evaluator.section
        offer.section = Section.find_by(identifier: evaluator.section)
      else
        offer.section_id = offer.divisions.first.section_id
      end

      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.all.sample ||
            FactoryBot.create(:language_filter)
        )
      end
    end

    after :create do |offer, evaluator|
      # Contact People
      offer.organizations.count.times do
        offer.contact_people << FactoryBot.create(
          :contact_person, organization: offer.organizations.first
        )
      end

      # ...
      create_list :hyperlink, evaluator.website_count, linkable: offer
      evaluator.tag_count.times do
        offer.tags <<
          FactoryBot.create(
            :tag
          )
      end
      evaluator.opening_count.times do
        offer.openings << (
          if Opening.count != 0 && rand(2).zero?
            Opening.select(:id).all.sample
          else
            FactoryBot.create(:opening)
          end
        )
      end
      evaluator.audience_count.times do
        offer.target_audience_filters << (
          TargetAudienceFilter.all.sample ||
            FactoryBot.create(:target_audience_filter)
        )
      end
    end

    trait :approved do
      after :create do |offer, _evaluator|
        Offer.where(id: offer.id).update_all aasm_state: 'approved',
                                             approved_at: Time.zone.now
        offer.reload
      end
      approved_by { FactoryBot.create(:researcher).id }
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
          :email_id, FactoryBot.create(:email).id
        )
      end
    end

    trait :with_location do
      encounter 'personal'
    end

    # trait :remote do
    #   encounter %w(hotline chat forum email online-course portal).sample
    # end

    trait :with_dummy_translations do
      after :create do |offer, _evaluator|
        (I18n.available_locales - [:de]).each do |locale|
          FactoryBot.create(
            :offer_translation,
            offer: offer,
            locale: locale,
            source: 'GoogleTranslate',
            name: "#{locale}(#{offer.name})",
            description: "#{locale}(#{offer.description})",
            old_next_steps: "GET READY FOR CANADA! (#{locale})",
            opening_specification: offer.opening_specification ? locale : nil
          )

          offer.organizations.each do |organization|
            FactoryBot.create(
              :organization_translation,
              organization: organization,
              locale: locale,
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
