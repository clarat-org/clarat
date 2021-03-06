# frozen_string_literal: true

FactoryGirl.define do
  factory :division do
    addition 'default division addition'
    section { Section.first || FactoryGirl.create(:section) }
    city { City.all.sample }
    area { Area.last || FactoryGirl.create(:area) }
    organization { FactoryGirl.create(:organization, :approved) }

    # after :create do |division, _evaluator|
    #   division.assignments <<
    #     FactoryGirl.create(
    #       :assignment,
    #       assignable_type: 'Division',
    #       assignable_id: division.id
    #     )
    # end
  end
end
