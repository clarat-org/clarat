require_relative '../test_helper'

feature 'Organization display' do
  scenario 'Organization with map and pdf website gets shown' do
    orga = FactoryGirl.create :organization, :approved
    hq = FactoryGirl.create :location, :hq, organization: orga
    orga.websites = []
    orga.websites << FactoryGirl.create(:website, :pdf)
    visit organization_path orga
    page.must_have_content orga.name
    page.must_have_content hq.street
    page.body.must_match(
      '<a href="http://www.t.com/t.pdf" target="_blank">www.t.com (PDF)</a>'
    )
  end
end
