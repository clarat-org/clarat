if set.any?
  json.set set do |subset|
    parent = subset[0]
    children = subset[1]

    json.name parent.name
    json.list_classes category_list_classes(depth, children)
    json.partial! 'offers/index/categories_nest.json', set: children, depth: (depth + 1)

    # set.each do |category, children|
    #   name = category.name
    #   # li.Categories__listitem(
    #   #   class=category_list_classes(search_form, name, depth, children)
    #   # )
    #     link_to name,
    #             offers_path(search_form: search_form.category_focus(name)),
    #             class: 'btn', data: { category: name }
    #
    #     render 'offers/index/categories_nest', set: children, facets: facets,
    #                                            search_form: search_form,
    #                                            depth: (depth + 1)
    # end
  end
end
