# frozen_string_literal: true

module OffersHelper
  # put spaces in telephone number: 0303656558 -> 030 36 56 55 8
  def tel_format number
    output = ''
    number.split('').each_with_index do |c, i|
      output += i.even? ? " #{c}" : c
    end
    output
  end

  def offer_with_contacts offer
    offer.contact_people.order('last_name ASC').order('first_name ASC')
  end

  def display_contacts? offer, contact
    !offer.hide_contact_people || contact.spoc
  end

  def contact_name contact
    if contact.last_name?
      contact_gender(contact).to_s +
        contact_academic_title(contact).to_s +
        contact_full_name(contact).to_s
    elsif contact.first_name?
      contact.first_name
    elsif contact.operational_name?
      contact.operational_name
    end
  end

  def contact_gender contact
    if contact.gender?
      gender = t "offers.show.who_contact_people.#{contact.gender}"
      "#{gender} "
    end
  end

  def contact_academic_title contact
    if contact.academic_title?
      title = t "offers.show.who_contact_people.#{contact.academic_title}"
      "#{title} "
    end
  end

  def contact_full_name contact
    if contact.first_name? && contact.last_name?
      "#{contact.first_name} #{contact.last_name}"
    elsif contact.last_name?
      contact.last_name
    end
  end
end
