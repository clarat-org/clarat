require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Admin Backend' do
  let(:admin) { FactoryGirl.create :admin }

  before { login_as admin }

  scenario 'Administrating Offers' do
    organization = FactoryGirl.create :organization

    visit rails_admin_path

    click_link 'Angebote', match: :first
    click_link 'Neu hinzufügen'

    assert_difference 'Offer.count', 1 do
      fill_in 'offer_name', with: 'testangebot'
      fill_in 'offer_description', with: 'testdescription'
      fill_in 'offer_next_steps', with: 'testnextsteps'
      select 'Fixed', from: 'offer_encounter'
      select organization.name, from: 'offer_organization_id'

      click_button 'Speichern'
      page.must_have_content 'testangebot'
    end
  end

  scenario 'Administrating Organizations' do

    visit rails_admin_path

    click_link 'Organisationen', match: :first
    click_link 'Neu hinzufügen'

    assert_difference 'Organization.count', 1 do
      fill_in 'organization_name', with: 'testorganisation'
      fill_in 'organization_description', with: 'testdescription'
      select 'e.V.', from: 'organization_legal_form'

      click_button 'Speichern'
      page.must_have_content 'testorganisation'
      page.must_have_content '✘'
      page.must_have_content admin.email
    end
  end
end
