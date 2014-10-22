require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Admin Backend' do
  before { login_as FactoryGirl.create :admin }

  scenario 'Administrating Offers' do
    organization = FactoryGirl.create :organization

    visit rails_admin_path

    click_link 'Angebote', match: :first
    click_link 'Neu hinzufügen'

    assert_difference 'Offer.count', 1 do
      fill_in 'offer_name', with: 'testname'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      select 'Fixed', from: 'offer_encounter'
      select organization.name, from: 'offer_organization_id'

      click_button 'Speichern'
    end
  end
end
