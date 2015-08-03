class InformEmailsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly.day(:monday).hour_of_day(7) }

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
      .joins(:offers).where('offers.approved = ?', true)
  end
end
