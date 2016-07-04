class ContactPeopleCell < Cell::ViewModel
  include Cell::Slim

  def show
    render
  end

  private

  def contacts
    model.contact_people.order('last_name DESC')
  end

  def each_contact_set &block
    contact_set = {}

    contacts.each_with_index do |contact, index|
      next if model.hide_contact_people && !contact.spoc

      contact_info =
        cell('contact_people_cell/contact_info', contact, index: index).to_s
      person_info = cell('contact_people_cell/person_info', contact).to_s

      contact_set[contact_info] ||= []
      contact_set[contact_info].push person_info
    end

    contact_set.each(&block)
  end

  def t string
    I18n.t("cells.contact_people#{string}")
  end

  class PersonInfoCell < ContactPeopleCell
    def show
      render(:person_info)
    end

    private

    def organization_name
      model.organization.name
    end
  end

  class ContactInfoCell < ContactPeopleCell
    def show
      render(:contact_info)
    end

    private

    include EmailObfuscationHelper

    def index
      options[:index]
    end

    # put spaces in telephone number: 0303656558 -> 030 36 56 55 8
    def tel_format number
      output = ''
      number.split('').each_with_index do |c, i|
        output += i.even? ? " #{c}" : c
      end
      output
    end

    def secure_email
      secure_email_to model.email_address, index
    end
  end
end
