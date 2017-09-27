# frozen_string_literal: true

require 'ffaker'

FactoryGirl.define do
  factory :update_request do
    search_location 'MyString'
    email { FFaker::Internet.email }
  end
end
