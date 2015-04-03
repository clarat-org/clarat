initFilterForm = ->

  filterExpand = ->

    $filterForm = $('.filter-form')
    startHeight = $('.col-form-inner:first').find('.radio_buttons').height() * 3.5
    expandLabel = 'Mehr Filter anzeigen'
    collapseLabel = 'Weniger Filter anzeigen'


    $filterForm
            .addClass 'filter-form--isCollapsed'
            .height startHeight

    if !$('.filter-form__expander').length
      $filterForm.prepend '<div class="filter-form__expander" role="button">' + expandLabel + '</div>'

    $expander = $('.filter-form__expander')

    $expander.attr 'aria-expanded', false

    $expander.on 'click', ->

      if $filterForm.hasClass('filter-form--isCollapsed')
        $expander
            .html collapseLabel
            .attr 'aria-expanded', true

        $filterForm
            .css 'height', 'auto'
            .removeClass 'filter-form--isCollapsed'
      else
        $expander
            .html expandLabel
            .attr 'aria-expanded', false

        $filterForm
              .css 'height', startHeight
              .addClass 'filter-form--isCollapsed'


  filterExpand()


$(document).ready initFilterForm
$(document).on 'page:load', initFilterForm
$(document).on 'ajax_replaced', initFilterForm
#$(window).on 'resize', initFilterForm