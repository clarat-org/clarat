class EmailsController < ApplicationController
  respond_to :html

  ## No use pretending this is RESTful

  def subscribe
    find_and_authorize_with_security_code
    @email.subscribe!
    flash[:success] = t('.success_html', unsubscribe_href:
      unsubscribe_path(id: @email.id, security_code: @email.security_code))
    redirect_to root_path
  end

  def unsubscribe
    find_and_authorize_with_security_code
    @email.unsubscribe!
    flash[:success] = t('.success_html', subscribe_href:
      subscribe_path(id: @email.id, security_code: @email.security_code))
    redirect_to root_path
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
end
