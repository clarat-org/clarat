# frozen_string_literal: true

FactoryGirl.define do
  factory :translation do
    locale 'de'
    source 'GoogleTranslate'

    factory :offer_translation, class: 'OfferTranslation' do
      offer_id { Offer.last.id || FactoryGirl.create(:offer).id }
      name 'default offer_translation name'
      description 'default offer_translation description'
    end

    factory :organization_translation, class: 'OrganizationTranslation' do
      organization
      description 'default organization_translation description'
    end
  end
end
