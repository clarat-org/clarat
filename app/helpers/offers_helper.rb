module OffersHelper
  # put spaces in telephone number: 0303656558 -> 030 36 56 55 8
  def tel_format number
    output = ''
    number.split('').each_with_index do |c, i|
      output += i.even? ? " #{c}" : c
    end
    output
  end

  # Informative classes for category list display: how deep it's nested,
  # whether it's currently selected (active), if there are children below it
  def category_list_classes depth, children
    depth_class = "depth--#{depth}"
    children_class = children.any? ? 'has-children' : ''
    "#{depth_class} #{children_class}"
  end

  # collect search information for display in offers#index
  def search_results_info_headline search_form, search
    output = base_search_results_info_headline(search_form, search)

    unless search_form.category.blank?
      output += " in #{breadcrumb_path search_form}"
    end
    unless search_form.query.blank?
      output += ": &bdquo;#{search_form.query}&ldquo; "
      unless search_form.category.blank?
        output += remove_query_link search_form
      end
    end

    output + " (#{display_location_for(search_form)})"
  end

  # generate collections for radio buttons from enum arrays
  # Temporarily disable filter (than this method is not needed)
  # def i18n_collection values, include_blank = false
  #   output = values.map do |value|
  #     [t(".collection_names.#{value}"), value]
  #   end
  #   if include_blank
  #     output.unshift([t('.collection_names.blank'), nil])
  #   end
  #   output
  # end

  private

  def base_search_results_info_headline search_form, search
    main_hits = search.personal_hits || search.remote_hits
    t(
      ".#{search_form.contact_type}_offers",
      count: main_hits.nbHits
    )
  end

  # breadcrumps to active category
  def breadcrumb_path search_form
    output = ''
    ancestors = search_form.category_with_ancestors
    last_index = ancestors.length - 1
    search_form.category_with_ancestors.each_with_index do |category, index|
      output +=
        link_to category.name,
                offers_path(search_form: search_form.category_focus(category))
      output += ' > ' if index != last_index
    end
    output
  end

  def remove_query_link search_form
    link_to offers_path(search_form: search_form.empty) do
      '<i class="fa fa-times-circle"></i>'.html_safe
    end
  end

  def display_location_for search_form
    if search_form.location_fallback
      t('conf.default_location')
    else
      search_form.search_location
    end
  end
end
