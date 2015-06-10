module SearchFormHelper
  def custom_validity_reset_js
    "try{setCustomValidity('')}catch(e){}"
  end

  def custom_validity_js i18n_selector
    content = t("shareds.forms.#{i18n_selector}")
    "this.setCustomValidity('#{j(content)}')"
  end
end
