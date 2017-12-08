# frozen_string_literal: true

FactoryBot.define do
  factory :hyperlink do
    linkable { FactoryBot.create %i[offer location organization].sample }
    website
  end
end
