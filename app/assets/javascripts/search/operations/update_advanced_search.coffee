class Clarat.Search.Operation.UpdateAdvancedSearch
  @run: (model) ->
    fields =
      ['age', 'target_audience', 'exclusive_gender', 'language', 'contact_type']

    for field in fields
      currentIdentifier = model[field] or 'any'
      currentlySelectedField =
        $("#advanced_search ##{field}_#{currentIdentifier}")

      if currentlySelectedField.is 'input'
        currentlySelectedField.prop('checked', true)
      else if currentlySelectedField.is 'option'
        currentlySelectedField.prop('selected', true)
