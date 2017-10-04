# frozen_string_literal: true

module SearchFormHelper
  def custom_validity_reset_js
    "try{setCustomValidity('')}catch(e){}"
  end

  def custom_validity_js i18n_selector
    content = t("shareds.forms.#{i18n_selector}")
    "this.setCustomValidity('#{j(content)}')"
  end

  def geo_location params, geocoded
    if params[:city]
      file = YAML.load_file('config/city_locations.yml')
      file[params[:city]]
    else
      geocoded
    end
  end

  def location params, search_location
    if params[:city]
      file = YAML.load_file('config/city_names.yml')
      file[params[:city]]
    else
      search_location
    end
  end

  def display_where params
    if params[:city]
      'display:none'
    else
      'display:block'
    end
  end

  def target params
    if params[:action].include?('widget')
      '_blank'
    else
      '_self'
    end
  end
end
