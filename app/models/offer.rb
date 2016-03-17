# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'offer')

class Offer < ActiveRecord::Base
  # Frontend-only Methods

  def canonical_section
    section_filters.pluck(:identifier).first
  end

  def in_section? section
    section_filters.where(identifier: section).count > 0
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

  # returns the fixed sorted language_filters
  def language_filters_fixed
    fixed = LanguageFilter::FIXED_IDENTIFIER
    fixed.select { |l| language_filters.pluck(:identifier).include? l }
  end

  # returns the rest of the language_filters (w/o fixed), ordered by german name
  def language_filters_without_fixed
    remaining = LanguageFilter::REMAINING_IDENTIFIER
    language_filters.order(:name).pluck(:identifier)
      .select { |id| remaining.include? id }
  end

  def all_language_filters_sorted
    language_filters_fixed + language_filters_without_fixed
  end

  private

  def two_own_websites_and_one_pdf
    sites = websites.own.non_pdf.first(2)
    sites << websites.own.pdf.first
  end
end
