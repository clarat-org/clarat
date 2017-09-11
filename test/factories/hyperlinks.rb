FactoryGirl.define do
  factory :hyperlink do
    linkable { FactoryGirl.create [:offer, :location, :organization].sample }
    website
  end
end
