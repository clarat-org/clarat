require_relative '../test_helper'

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

  scenario 'Search with changed location is working correctly' do
    # root path => default location is used
    visit root_path
    page.must_have_field('search_form_search_location', with: 'Berlin')
    # change location and search => valid seach at the given location
    fill_in 'search_form_search_location', with: 'Köln'
    # manually fill in cookie values
    find('.main-search__submit').click
    page.must_have_content 'Suche'
    page.must_have_css '#category-tree'
    page.must_have_field('search_form_search_location', with: 'Köln')
  end

  # Methods

  scenario '#load_geolocation_values!' do
    cookies = { saved_search_location: 'Köln', saved_geolocation: '50.1, 6.9' }
    search_form = SearchForm.new(cookies)
    search_form.search_location.must_equal cookies[:saved_search_location]
    search_form.generated_geolocation.must_equal cookies[:saved_geolocation]
  end
end
