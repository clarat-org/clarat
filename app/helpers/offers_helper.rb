module OffersHelper
  # put spaces in telephone number: 0303656558 -> 030 36 56 55 8
  def tel_format number
    output = ''
    number.split('').each_with_index do |c, i|
      output += i.even? ? " #{c}" : c
    end
    output
  end

  # info classes for category list display
  def category_list_classes search_cache, name, depth, children
    active_class = search_cache.category_in_focus?(name) ? 'active' : ''
    depth_class = "depth--#{depth}"
    children_class = children.any? ? 'has-children' : ''
    "#{active_class} #{depth_class} #{children_class}"
  end

  # collect search information for display in offers#index
  def search_results_info_headline search_cache
    output = I18n.t('offers.shared.offers', count: search_cache.hit_count)

    unless search_cache.category.blank?
      output += " in #{breadcrumb_path search_cache}"
    end
    unless search_cache.query.blank?
      output += ": &bdquo;#{search_cache.query}&ldquo; "
      unless search_cache.category.blank?
        output += remove_query_link search_cache
      end
    end
    output + " (#{search_cache.search_location})"
  end

  private

  # breadcrumps to active category
  def breadcrumb_path search_cache
    output = ''
    ancestors = search_cache.category_with_ancestors
    last_index = ancestors.length - 1
    search_cache.category_with_ancestors.each_with_index do |category, index|
      output += link_to category.name,
                        offers_path(search_form: search_cache.focus(category))
      output += ' > ' if index != last_index
    end
    output
  end

  def remove_query_link search_cache
    link_to offers_path(search_form: search_cache.empty) do
      '<i class="fa fa-times-circle"></i>'.html_safe
    end
  end
end
