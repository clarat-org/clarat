require_relative '../test_helper'

feature 'Offer display' do
  scenario 'Offer gets shown' do
    offer = FactoryGirl.create :offer, :approved
    offer.contact_people.first.update_column :email, 'a@b.c' # test obfuscation
    visit offer_path offer
    page.must_have_content offer.name
    click_link offer.organizations.first.name
    page.must_have_content offer.name
  end
end
