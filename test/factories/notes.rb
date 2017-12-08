# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :note do
    text { FFaker::Lorem.sentence }
    topic { Note.enumerized_attributes.attributes['topic'].values.sample }

    user
    notable { FactoryBot.create %i[offer organization].sample }
    # referencable { maybe FactoryBot.create [:contact_person, :offer].sample }
  end
end
