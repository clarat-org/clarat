class ExpiringOffersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(1) }

  def perform
    Offer.where(
      'expires_at >= ?', Time.now.beginning_of_day
    ).where(
      'expires_at <= ?', Time.now.end_of_day
    ).find_each do |offer|
      OfferMailer.delay.expiring_mail offer.id
    end
  end
end
