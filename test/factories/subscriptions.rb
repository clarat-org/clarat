# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :subscription do
    email { FFaker::Internet.email }
  end
end
