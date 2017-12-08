# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :organization do
    # required
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    legal_form do
      Organization.enumerized_attributes.attributes['legal_form'].values.sample
    end
    charitable { FFaker::Boolean.maybe }
    website { FactoryBot.create(:website, host: 'own') }

    # optional
    founded { maybe((1980..Time.zone.now.year).to_a.sample) }
    mailings 'enabled'
    created_by { FactoryBot.create(:researcher).id }
    locations_count 1
    slug 'slug'
    # associations
    # transient do
    #   locations_count 1
    # end

    after :build do |orga|
      # Filters
      orga.umbrella_filters << (
        UmbrellaFilter.all.sample ||
          UmbrellaFilter.create(identifier: 'diakonie', name: 'Diakonie')
      )
    end

    after :create do |orga, evaluator|
      # Locations
      if orga.locations_count.positive?
        create_list :location, (evaluator.locations_count - 1),
                    organization: orga, hq: false
      end
      # create an initial assignment
      # orga.assignments <<
      #   FactoryBot.create(
      #     :assignment,
      #     assignable_type: 'Organization',
      #     assignable_id: orga.id
      #   )
    end

    # traits
    trait :approved do
      after :create do |orga, _evaluator|
        Organization.where(id: orga.id).update_all aasm_state: 'approved',
                                                   approved_at: Time.zone.now
        orga.reload
      end
      approved_by { FactoryBot.create(:researcher).id }
      approved_at { Time.zone.now }
    end

    trait :mailings_disabled do
      mailings 'force_disabled'
    end
  end
end

def maybe result
  rand(2).zero? ? nil : result
end
