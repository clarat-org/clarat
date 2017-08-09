# frozen_string_literal: true
FactoryGirl.define do
  factory :split_base do
    title 'my_split_base'
    solution_category

    transient do
      division_count { rand(1..2) }
    end

    after :build do |split_base, evaluator|
      evaluator.division_count.times do
        split_base.divisions << FactoryGirl.create(:division)
      end
    end
  end
end
