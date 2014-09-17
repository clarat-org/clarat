class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise
  before_action :authenticate_user!

  # Pundit
  # include Pundit
  # after_action :verify_authorized, :except => :index
  # after_action :verify_policy_scoped, :only => :index
end
