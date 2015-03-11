class ExpiringOffersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(1) }

  def perform
    expiring =
      Offer.where(
        'expires_at >= ?', Time.now.beginning_of_day
      ).where(
        'expires_at <= ?', Time.now.end_of_day
      )

    OfferMailer.delay.expiring_mail expiring.count, expiring.pluck(:id)
    puts 'unapproving:'
    expiring.find_each { |offer| puts offer.id }
    expiring.update_all approved: false
    puts 'unapproved'
  end
end
