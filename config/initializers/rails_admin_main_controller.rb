# See https://github.com/clarat-org/clarat/issues/226
# and http://blog.endpoint.com/2013/07/hasmany-filter-in-railsadmin.html
module RailsAdmin
  MainController.class_eval do
    def get_collection(model_config, scope, pagination)
      associations = model_config.list.fields
        .select { |f| f.type == :belongs_to_association || f.type == :has_many_association && !f.polymorphic?}.collect { |f| f.association.name }
      options = {}
      options = options.merge(:page => (params[:page] || 1).to_i,
        :per => (params[:per] || model_config.list.items_per_page)) if pagination
      options = options.merge(:include => associations) unless associations.blank?
      options = options.merge(get_sort_hash(model_config))
      options = options.merge(:query => params[:query]) if params[:query].present?
      options = options.merge(:filters => params[:f]) if params[:f].present?
      options = options.merge(:bulk_ids => params[:bulk_ids]) if params[:bulk_ids]
      objects = model_config.abstract_model.all(options, scope)
    end
  end
end
