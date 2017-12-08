# frozen_string_literal: true

FactoryBot.define do
  factory :area do
    name 'foobar'
    minlat 1.0
    maxlat 3.0
    minlong 1.5
    maxlong 3.5
  end
end
