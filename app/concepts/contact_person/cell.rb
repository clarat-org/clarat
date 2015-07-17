class ContactPerson::Cell < Cell::Concept
  include ::Cell::Slim

  # cache TODO

  property :id
  property :name
  property :name?
  property :first_name
  property :first_name?
  property :last_name
  property :last_name?
  property :gender
  property :academic_title
  property :operational_name
  property :operational_name?
  property :telephone_1
  property :telephone_2
  property :area_code_1
  property :area_code_2
  property :local_number_1
  property :local_number_1?
  property :local_number_2
  property :local_number_2?
  property :fax
  property :fax_area_code
  property :fax_number
  property :fax_number?
  property :email
  property :email?

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
