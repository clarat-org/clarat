class BroadcastMailer < ActionMailer::Base
  default from: 'post@clarat.com'

  def welcome contact_person
    @contact_person = contact_person

    mail to: contact_person.email
  end
end
