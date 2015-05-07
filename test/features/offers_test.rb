require_relative '../test_helper'

feature 'Offer display' do
  scenario 'Offer gets shown' do
    offer = FactoryGirl.create :offer, :approved
    offer.contact_people.first.update_column :email, 'a@b.c' # test obfuscation
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

  scenario 'Muliple contact perons are shown in the right order' do
    offer = FactoryGirl.create :offer, :approved
    offer.contact_people << FactoryGirl.create(
      :contact_person, organization: offer.organizations.first
    )
    offer.contact_people.last.update name: '',
                                     area_code_1: '030',
                                     local_number_1: '123456'
    visit offer_path offer
    page.body.must_match(
      /contact-person-list\"><li>Telefon:  <a href=\"tel:030123456\"/
    )
  end
end
