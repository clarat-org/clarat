# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_offer do
    offer
    organization do
      FactoryGirl.create :organization, :approved
    end
  end
end
