class ExpiringOffersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(3) }

  def perform
    expiring = Offer.where(expires_at: Time.zone.today)
    if expiring.count > 0
      OfferMailer.delay.expiring_mail expiring.count, expiring.pluck(:id)
      expiring.update_all approved: false
      expiring.update_all unapproved_reason: 'expired'
    end
  end
end
