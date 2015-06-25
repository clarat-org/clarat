class BroadcastMailer < ActionMailer::Base
  default from: 'Anne Schulze | clarat <anne.schulze@clarat.org>'

  def welcome offer
    @contact_person = offer.contact_people.first
    @offer = offer

    mail to: @contact_person.email
  end
end
