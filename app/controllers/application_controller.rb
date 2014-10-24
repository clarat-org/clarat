class ApplicationController < ActionController::Base
  include Arcane

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise
  before_action :authenticate_user!

  # Pundit
  include Pundit
  after_action :verify_authorized_with_exceptions, except: :index
  after_action :verify_policy_scoped_with_exceptions, only: :index

  # Misc
  before_action :set_default_search_cache
  def set_default_search_cache
    @search_cache ||= SearchForm.new
  end

  protected

    def verify_authorized_with_exceptions
      verify_authorized unless pundit_unverified_controller
    end

    def verify_policy_scoped_with_exceptions
      verify_policy_scoped unless pundit_unscoped_controller
    end

    def pundit_unverified_controller
      (pundit_unverified_modules.include? self.class.name.split("::").first)||
      (pundit_unverified_classes.include? self.class.name)
    end

    def pundit_unscoped_controller
      (pundit_unverified_modules.include? self.class.name.split("::").first)||
      (pundit_unscoped_classes.include? self.class.name)
    end

    def pundit_unverified_modules
      ['Devise', 'RailsAdmin']
    end

    def pundit_unverified_classes
      ['PagesController']
    end

    def pundit_unscoped_classes
      ['OffersController']
    end

end
