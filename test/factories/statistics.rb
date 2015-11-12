FactoryGirl.define do
  factory :statistic do
    topic { Statistic::TOPICS.sample }
    user { FactoryGirl.create :researcher }
    x { Date.current }
    y { rand(1..99) }
  end
end
