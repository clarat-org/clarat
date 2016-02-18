class Clarat.Search.Cell.Pagination
  constructor: (@results) ->
    return @paginationViewObject()

  paginationViewObject: =>
    if @results.nbPages < 2 # If not enough results for pagination
      return {}

    return pagination =
      forward_text: I18n.t("js.search.pagination.next")
      backward_text: I18n.t("js.search.pagination.back")
      pages: @pages()
      prev_page: @prevPage()
      next_page: @nextPage()

  # Process pagination
  pages: ->
    pages = []
    totalPages = @results.nbPages
    currentPage = @results.page

    if currentPage > 5
      pages.push link: true, text: 1
      pages.push link: false, text: I18n.t("js.search.pagination.gap"), class: 'gap'

    for p in [(currentPage - 5)..(currentPage + 5)]
      if p < 0 or p >= totalPages
        continue

      pages.push
        link: (currentPage isnt p)
        text: p + 1
        class: if currentPage is p then 'current'

    if currentPage + 5 < totalPages
      pages.push link: false, text: I18n.t("js.search.pagination.gap"), class: 'gap'
      pages.push link: true, text: totalPages

    pages

  prevPage: ->
    if @results.page > 0
      @results.page
    else
      false

  nextPage: ->
    if @results.page + 1 < @results.nbPages
      @results.page + 2
    else
      false
