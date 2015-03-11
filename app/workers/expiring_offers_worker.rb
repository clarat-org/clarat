class ExpiringOffersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(1) }

  def perform
    puts Time.now.beginning_of_day
    puts Time.now.end_of_day
    expiring =
      Offer.where(
        expires_at: Date.current
      )

    OfferMailer.delay.expiring_mail expiring.count, expiring.pluck(:id)
    puts '2:'
    o = Offer.find(2)
    if o
      puts o.expires_at
      puts o.expires_at >= Time.now.beginning_of_day
      puts o.expires_at <= Time.now.end_of_day

    end
    puts 'unapproving:'
    expiring.find_each { |offer| pp offer.attributes }
    expiring.update_all approved: false
  end
end
