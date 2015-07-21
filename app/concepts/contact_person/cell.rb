class ContactPerson::Cell < Cell::Concept
  include ::Cell::Slim

  # cache TODO

  property :id,
           :name, :name?,
           :first_name, :first_name?,
           :last_name, :last_name?,
           :gender,
           :academic_title,
           :operational_name, :operational_name?,
           :telephone_1, :telephone_2,
           :area_code_1, :area_code_2,
           :local_number_1, :local_number_1?,
           :local_number_2, :local_number_2?,
           :fax, :fax_area_code, :fax_number, :fax_number?,
           :email, :email?

  def show
    render
  end

  private

  def t key # waiting for https://github.com/apotonick/cells/issues/272
    I18n.t "contact_people.show#{key}"
  end

  def tel_format number
    # TODO
  end

  def secure_email_to x, y
    # TODO
  end
end
