require_relative '../test_helper'

feature 'Offer display' do
  scenario 'Offer gets shown' do
    offer = FactoryGirl.create :offer, :approved
    offer.contact_people.first.create_email address: 'a@b.c' # test obfuscation
    visit offer_path offer
    page.must_have_content offer.name
    click_link offer.organizations.first.name
    page.must_have_content offer.name
  end

  scenario 'Offer view has evaluated markdown' do
    offer = FactoryGirl.create :offer, :approved,
                               description: 'A [link](http://www.example.org)',
                               next_steps: "A\n\n- list"

    visit offer_path offer
    page.must_have_link 'link'
    page.body.must_match %r{\<ul\>\n\<li\>list\</li\>\n\</ul\>}
  end

  scenario 'Offer view has explained words' do
    Definition.create key: 'complex', explanation: 'Explained!'
    offer = FactoryGirl.create :offer, :approved,
                               description: 'A complex sentence.'

    visit offer_path offer
    page.body.must_match(
      %r{\<p\>A \<dfn class='JS-tooltip' data-id='1'\>complex\</dfn\> sentence.\</p\>}
    )
  end

  scenario 'Muliple contact persons are shown in the right order' do
    offer = FactoryGirl.create :offer, :approved
    offer.contact_people << FactoryGirl.create(
      :contact_person, :just_telephone, organization: offer.organizations.first
    )
    visit offer_path offer
    page.body.must_match(
      '030  12 34 56</a><br /></li></ul>'
    )
  end

  scenario 'With a non PDF and PDF own website' do
    offer = FactoryGirl.create :offer, :approved
    offer.websites = []
    offer.websites << FactoryGirl.create(:website, :pdf)
    offer.websites << FactoryGirl.create(:website, :own)
    visit offer_path offer
    page.body.must_match(
      '<a href="http://www.example.com/" target="_blank">Webseite</a> | <a href="http://www.t.com/t.pdf" target="_blank">Webseite (PDF)</a>'
    )
  end
end
