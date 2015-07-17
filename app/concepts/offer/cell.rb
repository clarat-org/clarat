class Offer::Cell < Cell::Concept
  include ::Cell::Slim
  property :name

  def show
    render
  end

  private

  def t key # waiting for https://github.com/apotonick/cells/issues/272
    I18n.t "offers.show#{key}"
  end

  def general_information
    cell 'offer/cell/general_information', model
  end

  def has_contact_people?
    model.contact_people.any?
  end

  def show_contact_people
    concept 'contact_person/cell', collection: model.contact_people.by_name
  end


  def who_section_if_content
    return unless model.contact_people
    cell 'offer/cell/who_section', model
  end

  def website_section_if_websites_present
    return if model.websites.count < 1
    cell 'offer/cell/website_section', model
  end

  def organization_and_location_section
    cell 'offer/cell/organization_and_location_section', model
  end

  class GeneralInformationCell < Offer::Cell
    # cache :show

    property :description_html
    property :next_steps_html

    def show
      render 'general_information'
    end

    private

    def t key # waiting for https://github.com/apotonick/cells/issues/272
      I18n.t "offers.show.general_information#{key}"
    end
  end

  class WebsiteSectionCell < Offer::Cell
    def show
      render 'website_section'
    end

    private

    def t key # waiting for https://github.com/apotonick/cells/issues/272
      I18n.t "offers.show.website_section#{key}"
    end

    def websites
      model.structured_websites
    end

    def last_index
      websites.count - 1
    end
  end

  class OrganizationAndLocationSectionCell < Offer::Cell
    property :location

    def show
      render 'organization_and_location_section'
    end

    private

    def t key # waiting for https://github.com/apotonick/cells/issues/272
      I18n.t "offers.show.organization_and_location_section#{key}"
    end

    def show_location
      concept 'location/cell', model.location
    end

    def show_organization
      concept 'organization/cell', collection: model.organizations,
                                   method: :tiny
    end
  end
end
