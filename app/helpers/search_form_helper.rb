module SearchFormHelper
  SAMPLE_QUERIES = %w(
    Adoption Drogen Gewalt Nachhilfe Notfall Recht Selbstmord Waise
    arbeitslos essen krank obdachlos rauchen schwanger schwul schwänzen wohnen
  )

  def search_query_placeholder
    output = I18n.t('shared.abbr.example') + ' '
    output += SAMPLE_QUERIES.sample(2).join ', '
    output + ', …'
  end

  def custom_validity_reset_js
    "try{setCustomValidity('')}catch(e){}"
  end

  def custom_validity_js i18n_selector
    content = I18n.t("shared.forms.#{i18n_selector}")
    "this.setCustomValidity('#{j(content)}')"
  end
end
