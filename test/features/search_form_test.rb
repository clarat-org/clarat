require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Search Form' do

  scenario 'Empty search works' do
    WebMock.enable!
    visit root_path
    find('.btn.btn-xlg.btn-aligned.icon-white').click
    page.must_have_content '0 Ergebnisse'
    WebMock.disable!
  end

  scenario 'Search for unknown location leads to error page' do
    visit root_path
    fill_in 'search_form_search_location', with: 'Bielefeld'
    find('.btn.btn-xlg.btn-aligned.icon-white').click
    page.must_have_content 'Standort "Bielefeld" nicht gefunden'
  end

  scenario 'Search for standard string leads to error page' do
    visit root_path
    fill_in 'search_form_search_location', with: I18n.t('conf.current_location')
    find('#search_form_generated_geolocation').set '' # done by JS
    find('.btn.btn-xlg.btn-aligned.icon-white').click
    page.must_have_content "Standort \"#{I18n.t('conf.current_location')}\" nicht gefunden"
  end

end
