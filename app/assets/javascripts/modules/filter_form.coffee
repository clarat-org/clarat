initFilterForm = ->
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

  fieldsetHeadlineClickHandler = ->

    if ($(window).width() <= 440)

      $('.filter-form')
        .removeClass 'filter-form--isCollapsed'
        .css 'height', 'auto'
        .find('.col-form-inner .input').addClass 'is--hidden'

      $('.filter-form').find('.filter-form__fieldset__headline').attr 'aria-collapsed', true

      $('.filter-form__fieldset__headline').on 'click', ->

        that = $(this)

        that.next(".input").toggleClass 'is--hidden'

        if that.attr('aria-collapsed') == 'true'
          that.attr('aria-collapsed', 'false')
        else
          that.attr('aria-collapsed', 'true')

    else
      $('.filter-form')
        .find('.col-form-inner .input').removeClass 'is--hidden'
      .find('filter-form__fieldset__headline').attr 'aria-collapsed', 'true'

  filterExpand()
  fieldsetHeadlineClickHandler()


$(document).ready -> initFilterForm()

$(document).on 'ajax_replaced', -> initFilterForm()

$(document).on 'page:load', -> initFilterForm()

$(window).on 'resize', -> initFilterForm()
