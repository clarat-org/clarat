require 'trailblazer/autoloading'

# might be removable in future versions
Trailblazer::Operation::CRUD.module_eval do
  module Included
    def included(base)
      super # the original CRUD::included method.
      base.send :include, Trailblazer::Operation::CRUD::ActiveModel
    end
  end
  extend Included # override CRUD::included.
end
