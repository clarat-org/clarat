require_relative '../test_helper'

describe ContactPersonOffer do
  let(:contact_person_offer) { ContactPersonOffer.new }

  it "must be valid" do
    contact_person_offer.must_be :valid?
  end
end
