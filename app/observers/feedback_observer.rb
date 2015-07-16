class FeedbackObserver < ActiveRecord::Observer
  # email contact to admin
  def after_create contact
    FeedbackMailer.delay.admin_notification(contact.id)
  end
end
