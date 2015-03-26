# @todo: build main switch/accordeon for filter-form

initFilterForm = ->

  filterExpand = ->

    $filterForm = $('.filter-form')
    startHeight = $('.col-form-inner:first').find('.radio_buttons').height()  * 3.5
    expandLabel = 'Mehr Filter anzeigen'
    collapseLabel = 'Weniger Filter anzeigen'

    $filterForm
            .addClass 'filter-form--isCollapsed'
            .height startHeight
            .prepend '<div class="filter-form__expander">' + expandLabel + '</div>'

    $expander = $('.filter-form__expander')

    $expander.on 'click', ->

      if $filterForm.hasClass('filter-form--isCollapsed')
        $expander.html collapseLabel
        $filterForm
            .css 'height', 'auto'
            .removeClass 'filter-form--isCollapsed'
      else
        $expander.html expandLabel
        $filterForm
              .css 'height', startHeight
              .addClass 'filter-form--isCollapsed'


  filterExpand()


$(document).ready initFilterForm
$(document).on 'page:load', initFilterForm