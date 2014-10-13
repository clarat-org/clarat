require_relative '../test_helper'
include Warden::Test::Helpers

feature "Admin Backend" do
  before { login_as FactoryGirl.create :admin }

  scenario 'Administrating Offers' do
    organization = FactoryGirl.create :organization

    visit rails_admin_path

    click_link 'Offers', match: :first
    click_link 'Add new'

    assert_difference 'Offer.count', 1 do
      fill_in 'offer_name', with: 'testname'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      select 'Fixed', from: 'offer_encounter'
      select organization.name, from: 'offer_organization_id'

      click_button 'Save'
    end
  end
end
