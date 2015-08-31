# Worker to check bi-weekly, whether there are emails that
# - have subscribed to updates about new approved offers
# - have approved offers that do not yet have an OfferMailing
# and send each of them a compound email about the new offers.
class SubscribedEmailsMailingsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(2).day(:monday).hour_of_day(20) }

  def perform
    Offer.transaction do
      Email.transaction do
        potentially_informable_emails.find_each do |email|
          informable_offers = email.not_yet_but_soon_known_offers
          next if informable_offers.empty?
          OfferMailer.newly_approved_offers(email, informable_offers).deliver
        end
      end
    end
  end

  private

  def potentially_informable_emails
    Email.where(aasm_state: 'subscribed').uniq
      .joins(:offers).where('offers.aasm_state = ?', 'approved')
      .joins(:organizations).where('organizations.mailings_enabled = ?', true)
  end
end
