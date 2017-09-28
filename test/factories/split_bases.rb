# frozen_string_literal: true
FactoryGirl.define do
  factory :split_base do
    title 'my_split_base'
    solution_category

    transient do
      division_count { rand(1..2) }
      section nil
      organizations []
    end

    after :build do |split_base, evaluator|
      division_options = {}
      if evaluator.section
        division_options[:section] =
          Section.find_by identifier: evaluator.section
      end

      if evaluator.organizations.any?
        evaluator.organizations.each do |orga|
          division =
            if evaluator.section
              orga.divisions.joins(:section)
                  .where('sections.identifier = ?', evaluator.section).first
            else
              orga.divisions.sample
            end
          unless division
            division =
              FactoryGirl.create(
                :division, division_options.merge(organization: orga)
              )
          end
          split_base.divisions.push << division
        end
      else
        evaluator.division_count.times do
          split_base.divisions << FactoryGirl.create(:division, division_options)
        end
      end
    end
  end
end
