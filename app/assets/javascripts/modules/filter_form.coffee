# Wraps initMobileFilterSwitch, initFilterExpand, initFieldsetHeadlineClickHandler

initFilterForm = ->

  # General handling of shortening/teasing complete form for advanced search.
  # Starts collapsed, unless it detects otherwise in sessionStorage

  initFilterExpand = ->

    $filterForm = $('.filter-form')
    startHeight =
      $filterForm.find('.col-form-inner:first').find('.radio_buttons').height()
    startHeight = startHeight * 2.8
    expandLabel = I18n.t 'js.more_filter_options'
    collapseLabel = I18n.t 'js.less_filter_options'
    offer_filter_open = sessionStorage.getItem("offer_filter_open")

    # Detect or set state: offer_filter_open
    unless offer_filter_open == "true"
      $filterForm
              .addClass 'filter-form--isCollapsed'
              .css 'height', startHeight
      $('.filter-form__expander').attr 'aria-expanded', true

      sessionStorage.setItem("offer_filter_open", "false")

    # Prepend expander button dynamically
    if !$('.filter-form__expander').length
      $filterForm.prepend '<div class="filter-form__expander" role="button" aria-collapsed="true">' + expandLabel + '</div>'

      if offer_filter_open == "true"
        $('.filter-form__expander')
          .html collapseLabel
          .attr 'aria-collapsed', false

    # var $expander here, after creation
    $expander = $('.filter-form__expander')

    # Click handling for expander button click
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
            .attr 'aria-collapsed', true

        $filterForm
              .css 'height', startHeight
              .addClass 'filter-form--isCollapsed'

        sessionStorage.setItem("offer_filter_open", "false")

  # In mediaquery 's', the inner fieldsets of the advanced search form collapse
  # and the fieldset headlines get click handlers

  initFieldsetHeadlineClickHandler = ->

    # Detect if in mediaquery 's'

    if ($(window).width() <= 440)

      $('.filter-form')
        .removeClass 'filter-form--isCollapsed'
        .css 'height', 'auto'
        .find('.col-form-inner .input').addClass 'is--hidden'

      $('.filter-form').find('.filter-form__fieldset__headline').attr 'aria-collapsed', true

      # Click event

      $('.filter-form__fieldset__headline').on 'click', ->

        that = $(this)

        # Toggle fieldset contents visibility
        that.next(".input").toggleClass 'is--hidden'

        if that.attr('aria-collapsed') == 'true'
          that.attr('aria-collapsed', 'false')
        else
          that.attr('aria-collapsed', 'true')

    # If not in 's', but resizing to 'm' or bigger, revert form in case of need

    else
      $('.filter-form')
        .find('.col-form-inner .input').removeClass 'is--hidden'
      .find('filter-form__fieldset__headline').attr 'aria-collapsed', 'true'


  # In mediaquery 's', the whole advanced search form collapses (not just only
  # teaser look, like collapsed state on desktop)
  # Dynamically adding the according switch button here:

  initMobileFilterSwitch = ->

    label = I18n.t 'js.mobile_filter'

    if !$('.filter-form__switch').length  &&  ($(window).width() <= 440)
      $('.template--offers-index').find('.content-main').prepend(
        $('<button class="filter-form__switch" aria-collapsed="false">' +
          label + '</button>')
      )

    mobileFilterSwitch = $('.filter-form__switch')
    filterForm = $('.filter-form')

    # Detect if in mediaquery 's'

    if ($(window).width() <= 440)

      mobileFilterSwitch.show()
      filterForm.addClass 'is--hidden'

      # Click event

      mobileFilterSwitch.on 'click', ->
        filterForm.toggleClass 'is--hidden'

        that = $(this)

        if that.attr('aria-collapsed') == 'true'
          that.attr('aria-collapsed', 'false')

        else
          that.attr('aria-collapsed', 'true')

    else
      mobileFilterSwitch.remove()
      filterForm.removeClass 'is--hidden'

  # Calling subfunctions
  initMobileFilterSwitch()
  initFilterExpand()
  initFieldsetHeadlineClickHandler()


$(document).ready -> initFilterForm()

$(document).on 'ajax_replaced', -> initFilterForm()

$(document).on 'page:load', -> initFilterForm()

$(window).on 'resize', -> initFilterForm()
