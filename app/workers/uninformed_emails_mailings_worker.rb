# Worker to check bi-weekly, whether there are emails that
# - have not yet been informed
# - have approved offers
# - belongs to at least one organization that has `mailings_enabled: true`
# and trigger their inform event to send them a mailing each.
class UninformedEmailsMailingsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly(2).day(:monday).hour_of_day(20).minute_of_hour(30) }

  def perform
    Offer.transaction do
      Email.transaction do
        informable_emails.find_each(&:inform!)
      end
    end
  end

  private

  def informable_emails
    Email.where(aasm_state: 'uninformed').uniq
      .joins(:offers).where('offers.aasm_state = ?', 'approved')
      .joins(:organizations).where('organizations.mailings_enabled = ?', true)
  end
end
