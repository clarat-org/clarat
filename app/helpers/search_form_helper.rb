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
    case params[:city]
    when 'berlin' then '52.52000659999999,13.404954'
    when 'hamburg' then '53.5510846,9.9936818'
    when 'muenchen' then '48.1351253,11.5819806'
    when 'dortmund' then '51.5135872,7.465298100000001'
    else
      geocoded
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
