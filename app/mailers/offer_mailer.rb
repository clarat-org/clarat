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
    @offers = offers || email.offers.approved

    text = mail to: email.address,
                from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'

    email.update_log text
  end

  # Inform email addresses about new offers after they have subscribed.
  def new_offer email, offer
    @contact_people = email.contact_people
    @contact_person = @contact_people.first
    @multiple_contact_people = @contact_people.count > 1
    @offer = offer
    @unsubscribe_href =
      unsubscribe_url(id: email.id, security_code: email.security_code)

    email.update_log mail to: email.address,
                          from: 'clarat.org <post@clarat.org>'
  end
end
