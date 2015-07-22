class OfferMailer < ActionMailer::Base
  def expiring_mail offer_count, offer_ids
    @offer_count = offer_count
    @offer_ids = offer_ids
    mail subject: 'expiring offers',
         to:      Rails.application.secrets.emails['expiring'],
         from:    'post@clarat.org'
  end

  # Informing email addresses that they have offers listed on our platform.
  # @attr email Email object this is sent to
  # @attr offers variable only for test mails
  def inform email, offers = nil
    # Loads of variables in preparation for view models (TODO)
    @contact_people = email.contact_people
    @contact_person = @contact_people.first
    @multiple_contact_people = @contact_people.count > 1
    @offers = offers || email.offers.approved

    mail to: email.address
  end
end
