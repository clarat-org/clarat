require_relative '../test_helper'

feature 'Organization display' do
  scenario 'Organization with map gets shown' do
    orga = FactoryGirl.create :organization, :approved
    hq = FactoryGirl.create :location, :hq, organization: orga
    visit organization_path orga
    page.must_have_content orga.name
    page.must_have_content hq.street
  end
end
