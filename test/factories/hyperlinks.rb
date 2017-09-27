# frozen_string_literal: true

FactoryGirl.define do
  factory :hyperlink do
    linkable { FactoryGirl.create %i[offer location organization].sample }
    website
  end
end
