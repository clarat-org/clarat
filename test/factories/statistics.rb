# frozen_string_literal: true

FactoryBot.define do
  factory :statistic do
    topic { Statistic::TOPICS.sample }
    trackable { FactoryBot.create :researcher }
    x { Date.current }
    y { rand(1..99) }
  end
end
