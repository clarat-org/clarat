# frozen_string_literal: true

require_relative '../test_helper'

feature 'Organization display' do
  scenario 'Organization with map and website gets shown' do
    offer = offers(:basic)
    orga = offer.organizations.first
    orga.update_columns aasm_state: 'approved'
    orga.update_columns website_id: FactoryBot.create(:website, :own, url: 'http://a.t.com/').id
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.must_have_content orga.locations.first.street
    page.body.must_match(
      '<a target="_blank" href="http://a.t.com/">a.t.com</a>'
    )
  end

  scenario 'all_done organization with map and website gets shown' do
    offer = offers(:basic)
    orga = offer.organizations.first
    orga.update_columns aasm_state: 'all_done'
    orga.update_columns website_id: FactoryBot.create(:website, :own, url: 'http://a.t.com/').id
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.must_have_content orga.locations.first.street
    page.body.must_match(
      '<a target="_blank" href="http://a.t.com/">a.t.com</a>'
    )
  end

  scenario 'Organization with invisible location does not show it but shows'\
           'the website' do
    offer = offers(:basic)
    orga = offer.organizations.first
    orga.update_columns aasm_state: 'approved'
    orga.locations.first.update_columns visible: false
    orga.update_columns website_id: FactoryBot.create(:website, :own, url: 'http://a.t.com/').id
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.must_have_content orga.website.shorten_url
    page.must_have_content I18n.t 'organizations.show.where'
    page.wont_have_content orga.locations.first.street
  end

  scenario 'Organization with invisible location and without website does'\
           'not show where section' do
    offer = offers(:basic)
    orga = offer.organizations.first
    orga.update_columns aasm_state: 'approved'
    orga.locations.first.update_columns visible: false
    orga.update_columns website_id: nil
    visit unscoped_orga_path orga
    page.must_have_content orga.name
    page.wont_have_content orga.locations.first.street
    page.wont_have_content I18n.t 'organizations.show.where'
  end
end
