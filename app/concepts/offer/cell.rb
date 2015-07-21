class Offer::Cell < Cell::Concept
  include ::Cell::Slim

  property :name, :description_html, :next_steps_html, :opening_specification?,
           :opening_specification_html, :opening_details?
  property :contact_people, :location, :organizations, :openings

  def show
    render
  end

  private

  def t key # waiting for https://github.com/apotonick/cells/issues/272
    I18n.t "offers.show#{key}"
  end


  def contact_people?
    contact_people.any?
  end

  def show_contact_people
    concept 'contact_person/cell', collection: contact_people.by_name
  end


  def websites
    @_websites ||= model.structured_websites
  end

  def websites?
    websites.any?
  end

  def show_websites
    concept 'website/cell', collection: websites, last: websites.last
  end


  def show_location
    concept 'location/cell', location
  end


  def show_organizations
    concept 'organization/cell', collection: organizations, method: :tiny
  end


  def openings?
    openings.any?
  end

  def show_openings
    output = ''
    OpeningHash.new(model).each_open_day do |day, times|
      output +=
        concept('opening/cell', OpenStruct.new(day: day, times: times)).to_s
    end
    output
  end
end
