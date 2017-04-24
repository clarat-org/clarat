require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    old_next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    age_from { rand(1..3) }
    age_to { rand(4..6) }
    encounter do
      # weighted
      %w(personal personal personal personal hotline chat forum email online-course portal).sample
    end
    area { Area.first unless encounter == 'personal' }
    approved_at nil
    code_word { maybe FFaker::Lorem.words(rand(1..3)).join(' ').titleize }

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
      section nil
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
      section = evaluator.section
      if section
        offer.section = (
          Section.find_by_identifier(section) ||
            FactoryGirl.create(:section, identifier: section)
        )
      else
        offer.section = (
          Section.all.sample || FactoryGirl.create(:section)
        )
      end
      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.all.sample || FactoryGirl.create(:language_filter)
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
        offer.categories << evaluator.category
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
              description: "#{locale}(#{organization.untranslated_description})"
            )
          end
        end
      end
    end

    trait :with_markdown_and_definition do
      after :create do |offer, _evaluator|
        offer.update_column :description, Definition.infuse(
          MarkdownRenderer.render(offer.untranslated_description)
        )
        offer.update_column :old_next_steps, MarkdownRenderer.render(
          offer.untranslated_old_next_steps
        )
      end
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
