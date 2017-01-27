require_relative '../test_helper'

class VerySimpleTest < AcceptanceTest
  it 'should display something...', js: true do
    # offer = Offer.find(1)
    # page.driver.debug

    # visit "/#{offer.section_filters.first.identifier}/angebote/#{offer.slug}"
    visit '/family/kontakt/new'

    page.must_have_content 'Was möchtest du uns mitteilen?'
  end
end
