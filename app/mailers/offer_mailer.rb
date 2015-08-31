class OfferMailer < ActionMailer::Base
  def expiring_mail offer_count, offer_ids
    @offer_count = offer_count
    @offer_ids = offer_ids
    mail subject: 'expiring offers',
         to:      Rails.application.secrets.emails['expiring'],
         from:    'post@clarat.org'
  end

  # Informing email addresses for the first time that they have offers listed on
  # our platform.
  # @attr email Email object this is sent to
  # @attr offers variable only for test mails
  def inform email, offers = nil
    # Loads of variables in preparation for view models (TODO)
    @contact_people = email.contact_people
    @contact_person = @contact_people.first
    @multiple_contact_people = @contact_people.count > 1
    @offers = offers || email.offers.approved.by_mailings_enabled_organization
    @subscribe_href =
      subscribe_url(id: email.id, security_code: email.security_code)

    email.create_offer_mailings @offers, :inform
    mail to: email.address,
         from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end

  # Inform email addresses about new offers after they have subscribed.
  def newly_approved_offers email, offers
    @contact_people = email.contact_people
    @contact_person = @contact_people.first
    @multiple_contact_people = @contact_people.count > 1
    @offers = offers
    @offers_count = @offers.count
    @unsubscribe_href =
      unsubscribe_url(id: email.id, security_code: email.security_code)

    email.create_offer_mailings @offers, :newly_approved
    mail subject: t('.subject', count: @offers_count),
         to: email.address,
         from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'
  end
end
