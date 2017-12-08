# frozen_string_literal: true

require_relative '../test_helper'

feature 'Offer display' do
  scenario 'Approved offer gets shown' do
    offer = offers(:basic)
    visit unscoped_offer_path offer
    page.must_have_content offer.name_de
    click_link offer.organizations.first.name
    page.must_have_content offer.name_de
  end

  scenario 'Expired offer gets shown' do
    offer = offers(:basic)
    offer.update_columns aasm_state: 'expired'
    visit unscoped_offer_path offer
    page.must_have_content offer.name_de
    click_link offer.organizations.first.name
    page.must_have_content offer.name_de
  end

  scenario 'Approved offer gets shown in a different language (English)' do
    offer = FactoryBot.create :offer, :approved, :with_email,
                              :with_dummy_translations # test obfuscation
    # TranslationGenerationWorker.new.perform :en, 'Offer', offer.id

    visit offer_en_path offer, section: offer.section.identifier
    page.must_have_content 'GET READY FOR CANADA'
    page.must_have_css '.Automated-translation__warning'
  end

  scenario 'Expired offer gets shown in a different language (English)' do
    offer = FactoryBot.create :offer, :approved, :with_email,
                              :with_dummy_translations # test obfuscation
    offer.update_columns aasm_state: 'expired'
    visit offer_en_path offer, section: offer.section.identifier
    page.must_have_content 'GET READY FOR CANADA'
    page.must_have_css '.Automated-translation__warning'
  end

  scenario 'Offer view has evaluated markdown' do
    offer = FactoryBot.create :offer, :approved, :with_markdown,
                              description: 'A [link](http://www.example.org)',
                              old_next_steps: "A\n\n- list"

    visit unscoped_offer_path offer
    page.must_have_link 'link'
    page.body.must_match %r{\<ul\>\n\<li\>list\</li\>\n\</ul\>}
  end

  scenario 'Offer view displays new next steps instead of old if they exist' do
    offer = FactoryBot.create :offer, :approved, old_next_steps: 'Step one.'
    visit unscoped_offer_path offer
    page.must_have_content 'Step one.'
    page.wont_have_content 'basicNextStep'
    offer.next_steps << next_steps(:basic)
    visit unscoped_offer_path offer
    page.wont_have_content 'Step one.'
    page.must_have_content 'basicNextStep'
  end

  scenario 'Offer view displays translated old/new next steps' do
    offer = FactoryBot.create :offer, :approved, :with_dummy_translations,
                              old_next_steps: 'Step one.'
    # TranslationGenerationWorker.new.perform :en, 'Offer', offer.id
    offer.update_columns section_id: 2
    next_steps(:basic).update_column :text_en, 'English step 1.'
    visit offer_en_path offer, section: 'refugees'
    within '.section-content--nextsteps' do
      page.must_have_content 'GET READY FOR CANADA'
      page.wont_have_content 'English step 1.'
      page.must_have_css '.Automated-translation__warning'
    end
    offer.next_steps << next_steps(:basic)
    visit offer_en_path offer, section: offer.section.identifier
    within '.section-content--nextsteps' do
      page.wont_have_content 'GET READY FOR CANADA'
      page.must_have_content 'English step 1.'
      page.wont_have_css '.Automated-translation__warning'
    end
  end

  scenario 'Multiple contact persons are present' do
    offer = FactoryBot.create :offer, :approved
    offer.contact_people << FactoryBot.create(
      :contact_person, :all_fields, :with_telephone,
      organization: offer.organizations.first
    )
    visit unscoped_offer_path offer
    page.body.must_match(
      '030  12 34 56'
    )
  end

  scenario 'With a non PDF (document) and PDF (own) website' do
    offer = FactoryBot.create :offer, :approved
    offer.websites = []
    offer.websites << FactoryBot.create(:website, :pdf)
    offer.websites << FactoryBot.create(:website, :own)
    visit unscoped_offer_path offer
    page.body.must_match(
      '<a target="_blank" href="http://www.example.com/">www.example.com</a>'\
        ' | <a target="_blank" href="http://www.t.com/t.pdf">Weitere Infos'\
        ' (PDF)</a>'
    )
  end

  scenario 'With a non PDF and PDF (both own) website' do
    offer = FactoryBot.create :offer, :approved
    offer.websites = []
    offer.websites << FactoryBot.create(:website, :pdf, host: 'own')
    offer.websites << FactoryBot.create(:website, :own)
    visit unscoped_offer_path offer
    page.body.must_match(
      '<a target="_blank" href="http://www.example.com/">www.example.com</a>'\
        ' | <a target="_blank" href="http://www.t.com/t.pdf">www.t.com (PDF)</a>'
    )
  end

  scenario 'With three own websites, one of which is a pdf' do
    offer = FactoryBot.create :offer, :approved
    offer.websites = []
    offer.websites << FactoryBot.create(:website, :pdf, host: 'own')
    offer.websites << FactoryBot.create(:website, :own)
    offer.websites << FactoryBot.create(:website,
                                        host: 'own',
                                        url: 'http://www.example2.com/')
    visit unscoped_offer_path offer
    page.body.must_match(
      '<a target="_blank" href="http://www.example.com/">www.example.com</a>'\
        ' | <a target="_blank" href="http://www.example2.com/">www.example2.com'\
        '</a> | <a target="_blank" '\
        'href="http://www.t.com/t.pdf">www.t.com (PDF)</a>'
    )
  end
end
