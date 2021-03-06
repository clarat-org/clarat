# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :note do
    text { FFaker::Lorem.sentence }
    topic { Note.enumerized_attributes.attributes['topic'].values.sample }

    user
    notable { FactoryGirl.create %i[offer organization].sample }
    # referencable { maybe FactoryGirl.create [:contact_person, :offer].sample }
  end
end
