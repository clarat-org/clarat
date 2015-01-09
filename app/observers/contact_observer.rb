class ContactObserver < ActiveRecord::Observer
  # email contact to admin
  def after_create contact
    ContactMailer.delay.admin_notification(contact.id)
  end
end
