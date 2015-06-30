class BroadcastMailer < ActionMailer::Base
  default from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'

  # @attr contact_person Person the email is sent to
  # @attr offers variable only for test mails
  def welcome contact_person, offers = nil
    @contact_person = contact_person
    @offers = offers || contact_person.offers.approved

    mail to: @contact_person.email
  end
end
