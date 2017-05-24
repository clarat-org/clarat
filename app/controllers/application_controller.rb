# frozen_string_literal: true
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

  before_action :note_current_section, :session_cookie

  private

  def note_current_section
    @current_section = params[:section] || 'refugees'
  end

  def session_cookie
    date = Date.today
    visited_once  = 'visits=1'
    visited_twice = 'visits=2'

    if !cookies[:session]
      cookies[:session] = {
        value: "#{date.to_s}, #{visited_once}",
        expires: 28.days.from_now
      }
    elsif !cookies[:session].include? Date.today.to_s and @current_section
      if cookies[:session].include? visited_once
        cookies[:session] = {
          value: "#{date.to_s}, #{visited_twice}",
          expires: 28.days.from_now
        }
      elsif cookies[:session].include? visited_twice
        redirect_to new_contact_path(popup: true, section: @current_section)
        cookies.delete :session
      end
    end
  end

  ### Standard 404 Error ###

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError, with: :goto_404
    rescue_from ActionController::UnknownController, with: :goto_404
    rescue_from ActiveRecord::RecordNotFound, with: :goto_404
  end

  def goto_404
    locale_string = I18n.locale == :de ? '' : "/#{I18n.locale}"
    redirect_to "#{locale_string}/404"
  end
end
