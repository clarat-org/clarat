class ContactMailer < ActionMailer::Base
  def admin_notification contact_id
    @contact = Contact.find(contact_id)
    sender = @contact.email? ? @contact.email : 'unknown@clarat.org'
    mail subject: 'Neue Nachricht vom clarat-Kontaktfomular',
         to:      Rails.application.secrets.admin_email,
         from:    sender
  end
end
