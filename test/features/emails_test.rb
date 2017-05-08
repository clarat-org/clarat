# frozen_string_literal: true
require_relative '../test_helper'

feature 'emails#offers_index' do
  scenario 'offers_index for E-Mail with offers in section gets shown' do
    email = FactoryGirl.create :email
    offer1 = FactoryGirl.create :offer, :approved,
                                section: 'family', name: 'baz'
    offer2 = FactoryGirl.create :offer, :approved,
                                section: 'refugees', name: 'fuz'
    offer3 = FactoryGirl.create :offer, :approved,
                                section: 'family', name: 'foo'
    offer1.contact_people.first.update_column :email_id, email.id
    offer2.contact_people.first.update_column :email_id, email.id
    offer3.contact_people.first.update_column :email_id, email.id
    offer3.update_columns aasm_state: 'expired'
    visit emails_offers_path(section: 'family', id: email.id, locale: 'de')

    page.must_have_content 'baz'
    page.must_have_content 'foo' # expired family offer
    page.wont_have_content 'fuz' # because it's in different section
    page.wont_have_content email.address # because js obfuscated
  end

  scenario 'offers_index for E-Mail without offers in section gets shown' do
    email = FactoryGirl.create :email
    offer1 = FactoryGirl.create :offer, :approved,
                                section: 'family', name: 'baz'
    offer1.contact_people.first.update_column :email_id, email.id
    visit emails_offers_path(section: 'refugees', id: email.id, locale: 'de')

    page.wont_have_content 'baz' # because it's in different section
    page.must_have_content 'Es gibt derzeit keine veröffentlichten'\
                           ' clarat refugees-Angebote'
  end
end
