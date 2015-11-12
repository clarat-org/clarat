require_relative '../test_helper'

feature 'Organization display' do
  scenario 'Organization with map and website gets shown' do
    orga = FactoryGirl.create :organization, :approved
    orga.websites = []
    orga.websites << FactoryGirl.create(:website, :own, url: 'http://a.t.com/')
    visit organization_path orga
    page.must_have_content orga.name
    page.must_have_content orga.locations.first.street
    page.body.must_match(
      '<a href="http://a.t.com/" target="_blank">a.t.com</a>'
    )
  end
end
