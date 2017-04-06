class Clarat.Search.Operation.UpdateAdvancedSearch
  @run: (model) ->
    # Update dropdowns and radio buttons
    fields =
      ['age', 'target_audience', 'gender_first_part_of_stamp', 'language', 'contact_type', 'sort_order']

    for field in fields
      currentIdentifier = model[field] or 'any'
      currentlySelectedField = $("##{field}_#{currentIdentifier}")
      if !currentlySelectedField.length
        currentlySelectedField = $(".#{field}_#{currentIdentifier}")

      if currentlySelectedField.is 'input'
        currentlySelectedField.prop('checked', true)
      else if currentlySelectedField.is 'option'
        currentlySelectedField.prop('selected', true)

    if model.contact_type is 'personal'
      $('input[name=contact_type][value=personal]:checked').trigger(
        'Clarat.Search::InitialDisable'
      )

    @updateCheckboxes(model)

  # Update Checkboxes
  @updateCheckboxes: (model) ->
    for identifier in model.encounters.split(',')
      $("#advanced_search #encounter_#{identifier}").prop('checked', true)
