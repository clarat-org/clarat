require_relative '../test_helper'
include Warden::Test::Helpers

feature 'Search Form' do
  def with_xhr
    ActionDispatch::Request.any_instance.stubs(:xhr?).returns(true)
    yield
    ActionDispatch::Request.any_instance.stubs(:xhr?).returns(false)
  end

  scenario 'Empty search works' do
    WebMock.enable!
    visit root_path
    with_xhr do
      find('.main-search__submit').click
    end
    page.must_have_content 'Keine Vor-Ort-Angebote'
    WebMock.disable!
  end

  # scenario 'Search with results but none nearby shows overlay' do
  #   WebMock.enable!
  #   FactoryGirl.create :offer, name: 'bazfuz'
  #   Algolia.expects(:multiple_queries).returns(
  #     AlgoliaStubber.filled_response_stub('bazfuz', ['bazfuz'])
  #   )
  #   SearchResults.any_instance.expects(:empty?).returns(true)
  #
  #   visit root_path
  #   fill_in 'search_form_query', with: 'bazfuz'
  #   fill_in 'search_form_search_location', with: 'Foobar'
  #   with_xhr do
  #     find('.main-search__submit').click
  #   end
  #   page.must_have_content 'Ein Vor-Ort-Angebot'
  #
  #   page.must_have_content I18n.t 'offers.index.unavailable_location_modal'
  #   WebMock.disable!
  # end

  scenario 'Toggle category filters in search results' do
    WebMock.enable!
    o1 = FactoryGirl.create :offer, :with_location,
                            name: 'foo baz', category: 'chunky bacon'
    o2 = FactoryGirl.create :offer,
                            name: 'foo fuz', category: 'unrelated',
                            location: o1.location, organization_count: 0
    OrganizationOffer.create! offer_id: o2.id,
                              organization_id: o1.organizations.first.id

    Algolia.stubs(:multiple_queries).returns(
      AlgoliaStubber.filled_response_stub(
        'foo',
        ['foo baz', 'foo fuz'],
        'chunky bacon' => 1
      )
    )
    Rails.cache.clear

    visit root_path
    fill_in 'search_form_query', with: 'foo'
    fill_in 'search_form_search_location', with: 'Foobar'
    with_xhr do
      find('.main-search__submit').click
    end
    page.must_have_link 'foo baz'
    page.must_have_link 'foo fuz'

    # test non-xhr part
    visit root_path
    find('.main-search__submit').click
    click_link 'chunky bacon'
    current_url.must_match(
      /search_form\[category\]=chunky\+bacon/
    )
    # find_link('chunky bacon')[:href].wont_match(
    #   /search_form%5Bcategory%5D=chunky\+bacon/
    # )
    WebMock.disable!
  end

  scenario 'Search with exact_location works' do
    WebMock.enable!
    with_xhr do
      visit offers_path search_form: {
        query: nil, search_location: 'X', generated_geolocation: '0,0',
        categories: '', exact_location: 't'
      }
    end

    page.must_have_content 'Keine Vor-Ort-Angebote'
    WebMock.disable!
  end

  scenario 'Search for remote offers works' do
    WebMock.enable!
    with_xhr do
      visit offers_path search_form: {
        query: nil, search_location: 'Foobar', generated_geolocation: '0,0',
        categories: '', contact_type: 'remote'
      }
    end

    page.wont_have_content 'Keine Vor-Ort-Angebote'
    page.must_have_content 'Keine Telefon- und Onlineberatungen'
    WebMock.disable!
  end

  scenario 'Search for unknown location leads to error page' do
    visit root_path
    fill_in 'search_form_search_location', with: 'Bielefeld'
    with_xhr do
      find('.main-search__submit').click
    end
    page.must_have_content(
      'Leider konnten wir den von dir eingegeben Standort nicht finden'
    )
  end

  scenario 'Search for standard string leads to error page' do
    visit root_path
    fill_in 'search_form_search_location',
            with: I18n.t('conf.current_location')
    find('#search_form_generated_geolocation').set '' # unset by JS
    with_xhr do
      find('.main-search__submit').click
    end
    page.must_have_content(
      'Leider konnten wir den von dir eingegeben Standort nicht finden'
    )
  end

  scenario 'Search for js-generated standard string leads to results' do
    visit root_path
    fill_in 'search_form_search_location',
            with: I18n.t('conf.current_location')
    find('#search_form_generated_geolocation').set '4,2' # set by JS
    with_xhr do
      find('.main-search__submit').click
    end
    page.wont_have_content(
      'Leider konnten wir den von dir eingegeben Standort nicht finden'
    )
  end

  # scenario 'Navigating to category without a given location uses default' do
  #   WebMock.enable!
  #   visit root_path
  #   fill_in 'search_form_search_location', with: ''
  #
  #   click_link 'main1'
  #   page.must_have_content I18n.t 'offers.index.location_fallback'
  #   WebMock.disable!
  # end
end
