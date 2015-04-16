filterExpand = ->

  $filterForm = $('.filter-form')
  startHeight = $('.col-form-inner:first').find('.radio_buttons').height() * 2.5
  expandLabel = I18n.t 'js.more_filter_options'
  collapseLabel = I18n.t 'js.less_filter_options'
  offer_filter_open = sessionStorage.getItem("offer_filter_open")

  unless offer_filter_open == "true"
    $filterForm
            .addClass 'filter-form--isCollapsed'
            .height startHeight
    $('.filter-form__expander').attr 'aria-expanded', true

    sessionStorage.setItem("offer_filter_open", "false")


  if !$('.filter-form__expander').length
    $filterForm.prepend '<div class="filter-form__expander" role="button" aria-expanded="false">' + expandLabel + '</div>'

    if offer_filter_open == "true"
      $('.filter-form__expander')
        .html collapseLabel
        .attr 'aria-expanded', true

  $expander = $('.filter-form__expander')

  $expander.on 'click', ->

    if $filterForm.hasClass('filter-form--isCollapsed')
      $expander
          .html collapseLabel
          .attr 'aria-expanded', true

      $filterForm
          .css 'height', 'auto'
          .removeClass 'filter-form--isCollapsed'

      sessionStorage.setItem("offer_filter_open", "true")

    else
      $expander
          .html expandLabel
          .attr 'aria-expanded', false

      $filterForm
            .css 'height', startHeight
            .addClass 'filter-form--isCollapsed'

      sessionStorage.setItem("offer_filter_open", "false")


$(document).ready -> filterExpand()

$(document).on 'ajax_replaced', -> filterExpand()

$(document).on 'page:load', -> filterExpand()

$(window).on 'resize', -> filterExpand()