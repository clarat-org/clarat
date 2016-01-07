Clarat.StickySidebar = {}

class Clarat.StickySidebar.Presenter extends ActiveScript.Presenter

  CALLBACKS:
    window:
      load: 'stickSidebar'
      resize: 'stickSidebar'
    document:
      'Clarat.Search::CategoryClick': 'stickSidebar'
      'Clarat.Search::NewResults': 'stickSidebar'

  stickSidebar: =>
    if $('body.template--offers-index').length

      $window = $(window)
      contentHeight = $window.innerHeight()
      $sidebar = $(".template--offers-index").find(".aside-standard")
      sidebarHeight = $sidebar.outerHeight()
      $listing = $('.Listing-results')
      listingHeight = $listing.outerHeight()
      $container = $('.content-main--offers-index')
      isDesktop = $(document).width() >= 750
      isStickyScenario

      if isDesktop
        # Fake relative positioning, independently from sticky-ness:
        minHeight = if sidebarHeight > listingHeight then sidebarHeight else listingHeight

        $container.css('min-height', minHeight)

        console.log(contentHeight)
      else
        # Exit here, since feature is only applicable to two column xl layout
        return

      isStickyScenario = (listingHeight > contentHeight) && (sidebarHeight < listingHeight)

      if isStickyScenario

        # Init sticky-kit on sidebar
        $sidebar.stick_in_parent({
          spacer: false
        })

$(document).ready ->
  new Clarat.StickySidebar.Presenter