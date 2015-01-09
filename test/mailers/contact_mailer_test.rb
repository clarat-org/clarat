require_relative '../test_helper'

describe ContactMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:contact) { FactoryGirl.create(:contact) }

  describe '#admin_notification' do
    it 'must deliver' do
      mail = ContactMailer.admin_notification contact.id
      mail.must deliver_from contact.email

      mail.must have_body_text contact.name
      mail.must have_body_text contact.email
      mail.must have_body_text contact.created_at.to_s
      mail.must have_body_text contact.url
      mail.must have_body_text contact.message
    end
  end
end
