# using http://vast-engineering.github.io/jquery-popup-overlay/
Clarat.Modal =
  initializeAllModals:  ->
    modals = $('.JS-modal')
    for modal in modals
      $modal = $(modal)
      options = $modal.data()
      $modal.popup(options)

  open: (selector) ->
    $(selector).popup 'show'

  close: (selector) ->
    $(selector).popup 'hide'

$(document).ready Clarat.Modal.initializeAllModals
$(document).on 'page:load', Clarat.Modal.initializeAllModals
