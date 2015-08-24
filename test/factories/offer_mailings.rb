FactoryGirl.define do
  factory :offer_mailing do
    mailing_type do
      OfferMailing.enumerized_attributes.attributes['mailing_type']
        .values.sample
    end
    offer
    email
  end
end
