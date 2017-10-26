# frozen_string_literal: true

include ApplicationHelper

class EmailsController < ApplicationController
  respond_to :html

  ## No use pretending this is RESTful

  def subscribe
    find_and_authorize_with_security_code
    @email.subscribe!
    flash[:success] = t('.success_html', unsubscribe_href:
      unsubscribe_path(id: @email.id, security_code: @email.security_code))
    redirect_to section_choice_path
  end

  def unsubscribe
    find_and_authorize_with_security_code
    @email.unsubscribe!
    flash[:success] = t('.success_html', subscribe_href:
      subscribe_path(id: @email.id, security_code: @email.security_code))
    redirect_to section_choice_path
  end

  # List the offers of a certain email. Here we actually do pretend partial
  # RESTfulness
  def offers_index
    @email = Email.find params[:id]
    @offers = visible_offers_of_email(@email).in_section(params[:section])
                                             .order(updated_at: :desc)
    @inverse_offers_count = visible_offers_of_email(@email)
                            .in_section(inverse_section(params[:section])).count
  end

  private

  def find_and_authorize_with_security_code
    @email = Email.find params[:id]
    @email.given_security_code = params[:security_code]
    authorize @email
  end

  def pundit_user
    nil
  end

  def visible_offers_of_email email
    email.offers.visible_in_frontend
  end
end
