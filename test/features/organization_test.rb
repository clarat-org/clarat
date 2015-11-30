require_relative '../test_helper'

feature 'Organization display' do
  scenario 'Organization with map and website gets shown' do
    orga = FactoryGirl.create :organization, :approved
    orga.websites = []
    orga.websites << FactoryGirl.create(:website, :own, url: 'http://a.t.com/')
    FactoryGirl.create :offer, organization: orga
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.must_have_content orga.locations.first.street
    page.body.must_match(
      '<a href="http://a.t.com/" target="_blank">a.t.com</a>'
    )
  end

  scenario 'Organization with invisible location does not show it but shows'\
           'the website' do
    orga = FactoryGirl.create :organization, :approved
    orga.locations.first.update_columns visible: false
    orga.websites = []
    orga.websites << FactoryGirl.create(:website, :own, url: 'http://a.t.com/')
    FactoryGirl.create :offer, organization: orga
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.must_have_content orga.websites.first.shorten_url
    page.must_have_content I18n.t 'organizations.show.where'
    page.wont_have_content orga.locations.first.street
  end

  scenario 'Organization with invisible location and without website does'\
           'not show where section' do
    orga = FactoryGirl.create :organization, :approved
    orga.locations.first.update_columns visible: false
    orga.websites = []
    FactoryGirl.create :offer, organization: orga
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.wont_have_content orga.locations.first.street
    page.wont_have_content I18n.t 'organizations.show.where'
  end
end
