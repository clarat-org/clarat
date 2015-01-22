require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Search Form' do

  scenario 'Empty search works' do
    WebMock.enable!
    visit root_path
    find('.main-search__submit').click
    page.must_have_content '0 Angebote'
    WebMock.disable!
  end

  scenario 'Search with results' do
    WebMock.enable!
    FactoryGirl.create :offer, name: 'bazfuz'
    Offer.stubs(:algolia_search).returns(
      AlgoliaStubber.filled_response_stub('bazfuz', ['bazfuz'])
    )

    visit root_path
    fill_in 'search_form_query', with: 'bazfuz'
    fill_in 'search_form_search_location', with: 'Foobar'
    find('.main-search__submit').click
    page.must_have_content '1 Angebote'
    WebMock.disable!
  end

  scenario 'Toggle tag filters in search results' do # makes above redundant?
    WebMock.enable!
    o1 = FactoryGirl.create :offer, :with_location,
                            name: 'foo baz', tag: 'chunky bacon'
    FactoryGirl.create :offer,
                       name: 'foo fuz', tag: 'unrelated',
                       location: o1.location, organization: o1.organization
    Offer.stubs(:algolia_search).returns(
      AlgoliaStubber.filled_response_stub(
        'foo',
        ['foo baz', 'foo fuz'],
        'chunky bacon' => 1
      )
    )

    visit root_path
    fill_in 'search_form_query', with: 'foo'
    fill_in 'search_form_search_location', with: 'Foobar'
    find('.main-search__submit').click
    page.must_have_link 'foo baz'
    page.must_have_link 'foo fuz'

    click_link 'chunky bacon'
    current_url.must_match(
      /search_form\[tags\]=chunky\+bacon/
    )
    find_link('chunky bacon')[:href].wont_match(
      /search_form%5Btags%5D=chunky\+bacon/
    )
    WebMock.disable!
  end

  scenario 'Search for unknown location leads to error page' do
    visit root_path
    fill_in 'search_form_search_location', with: 'Bielefeld'
    find('.main-search__submit').click
    page.must_have_content 'Standort "Bielefeld" nicht gefunden'
  end

  scenario 'Search for standard string leads to error page' do
    visit root_path
    fill_in 'search_form_search_location',
            with: I18n.t('conf.current_location')
    find('#search_form_generated_geolocation').set '' # unset by JS
    find('.main-search__submit').click
    page.must_have_content(
      "Standort \"#{I18n.t('conf.current_location')}\" nicht gefunden"
    )
  end

  scenario 'Search for js-generated standard string leads to results' do
    visit root_path
    fill_in 'search_form_search_location',
            with: I18n.t('conf.current_location')
    find('#search_form_generated_geolocation').set '4,2' # set by JS
    find('.main-search__submit').click
    page.wont_have_content(
      "Standort \"#{I18n.t('conf.current_location')}\" nicht gefunden"
    )
  end

end
