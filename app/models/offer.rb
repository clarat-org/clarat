# frozen_string_literal: true
# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'offer')

class Offer < ActiveRecord::Base
  # Frontend-only Methods

  def canonical_section
    section.identifier
  end

  def visible_contact_people?
    return false unless contact_people.any?
    contact_people.each do |contact|
      return true if contact.spoc
    end
    !hide_contact_people
  end

  # Get an array of websites, ordered as follows: (1) 2x own non-pdf (2) own pdf
  # (3+) remaining HOSTS in order, except "other"
  def structured_websites
    sites = two_own_websites_and_one_pdf

    Website::HOSTS[1..-2].each do |host| # no "other"
      sites << websites.send(host).first
    end
    sites.compact
  end

  def organization_display_name
    if organizations.count == 1
      organization_names
    else
      I18n.t('js.search_results.map.cooperation')
    end
  end

  # structured information to build a gmap marker for this offer
  def gmaps_info
    {
      title: name,
      address: location_address,
      organization_display_name: organization_display_name
    }
  end

  def language_filters_alphabetical_sorted
    german_alphabetical = LanguageFilter::IDENTIFIER
    language_filters.order(:name).pluck(:identifier)
      .select { |id| german_alphabetical.include? id }
  end

  private

  def two_own_websites_and_one_pdf
    sites = websites.own.non_pdf.first(2)
    sites << websites.own.pdf.first
  end
end
