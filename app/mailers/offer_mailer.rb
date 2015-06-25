class OfferMailer < ActionMailer::Base
  def expiring_mail offer_count, offer_ids
    @offer_count = offer_count
    @offer_ids = offer_ids
    mail subject: 'expiring offers',
         to:      Rails.application.secrets.emails['expiring'],
         from:    'post@clarat.org'
  end
end
