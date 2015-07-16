require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Search Form' do
  scenario 'Valid search displays an empty page (that is later filled by JS)' do
    visit root_path
    find('.main-search__submit').click
    page.must_have_content 'Suche'
    page.must_have_css '#category-tree'
  end

  scenario 'Search for unknown location leads to error page' do
    visit root_path
    fill_in 'search_form_search_location', with: 'Bielefeld'
    find('.main-search__submit').click
    page.must_have_content(
      'Leider konnten wir den von dir eingegeben Standort nicht finden'
    )
  end
end
