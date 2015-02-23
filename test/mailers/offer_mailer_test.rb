require_relative '../test_helper'

describe OfferMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:offer) { offers(:basic) }

  describe '#expiring_mail' do
    it 'must deliver' do
      mail = OfferMailer.expiring_mail offer.id
      mail.must deliver_from 'noreply@clarat.org'
      mail.must have_body_text offer.id.to_s
    end
  end
end
