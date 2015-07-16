class ApplicationController < ActionController::Base
  include Arcane

  include Trailblazer::Operation::Controller
  require 'trailblazer/operation/controller/active_record'
  include Trailblazer::Operation::Controller::ActiveRecord

  # staging password protection
  clarat = Rails.application
  http_basic_authenticate_with name: clarat.secrets.protect['user'],
                               password: clarat.secrets.protect['pwd'],
                               if: -> { Rails.env.staging? }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise
  before_action :authenticate_user!, except: [:goto_404]

  # Pundit
  include Pundit
  after_action :verify_authorized_with_exceptions, except: :index
  after_action :verify_policy_scoped_with_exceptions, only: :index

  protected

  ### Pundit Helpers ###

  def verify_authorized_with_exceptions
    verify_authorized unless pundit_unverified_controller
  end

  def verify_policy_scoped_with_exceptions
    verify_policy_scoped unless pundit_unscoped_controller
  end

  def pundit_unverified_controller
    (pundit_unverified_modules.include? self.class.name.split('::').first) ||
      (pundit_unverified_classes.include? self.class.name)
  end

  def pundit_unscoped_controller
    (pundit_unverified_modules.include? self.class.name.split('::').first) ||
      (pundit_unscoped_classes.include? self.class.name)
  end

  def pundit_unverified_modules
    %w(Devise RailsAdmin)
  end

  def pundit_unverified_classes
    %w(PagesController)
  end

  def pundit_unscoped_classes
    %w(OffersController CategoriesController FeedbacksController)
  end

  ### / Pundit Helpers ###

  private

  ### Standard 404 Error ###

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :goto_404
    rescue_from ActionController::UnknownController, with: :goto_404
    rescue_from ActiveRecord::RecordNotFound, with: :goto_404
  end

  def goto_404
    redirect_to '/404'
  end
end
