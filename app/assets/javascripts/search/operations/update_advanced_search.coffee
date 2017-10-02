class Clarat.Search.Operation.UpdateAdvancedSearch
  @run: (model) ->
    # Update dropdowns and radio buttons
    fields =
      ['target_audience', 'exclusive_gender', 'language', 'sort_order', 'residency_status']

    for field in fields
      currentIdentifier = model[field] or 'any'
      currentlySelectedField = $("##{field}_#{currentIdentifier}")
      if !currentlySelectedField.length
        currentlySelectedField = $(".#{field}_#{currentIdentifier}")

      if currentlySelectedField.is 'input'
        currentlySelectedField.prop('checked', true)
      else if currentlySelectedField.is 'option'
        currentlySelectedField.prop('selected', true)
