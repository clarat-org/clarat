class ApplicationController < ActionController::Base
  include Arcane
  include Pundit

  # staging password protection
  clarat = Rails.application
  http_basic_authenticate_with name: clarat.secrets.protect['user'],
                               password: clarat.secrets.protect['pwd'],
                               if: -> { Rails.env.staging? }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Disable browser cache for the current response. Use as before_action.
  def disable_caching
    response.headers['Cache-Control'] =
      'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  # single site password protection
  # def self.password_protect
  #  http_basic_authenticate_with(
  #    name: Rails.application.secrets.protect['user'],
  #    password: Rails.application.secrets.protect['pwd']
  #  )
  # end

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
