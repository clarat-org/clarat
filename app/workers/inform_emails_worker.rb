class InformEmailsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly.minute_of_hour(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55) }

  def perform
    Offer.transaction do
      informable_emails.find_each(&:inform!)
    end
  end

  private

  def informable_emails
    Email.where(aasm_state: 'uninformed')
      .joins(:offers).where('offers.approved = ?', true)
  end
end
