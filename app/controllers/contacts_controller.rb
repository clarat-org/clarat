# Contact and report form
class ContactsController < ApplicationController
  respond_to :html, :js
  skip_before_action :verify_authenticity_token, only: :create

  def new
    @contact = Contact.new url: request.referrer
    respond_with @contact
  end

  def create
    @contact = Contact.new params.for(Contact).refine
    if @contact.save
      respond_to do |format|
        format.html { redirect_to root_path, flash: { success: t('.success') } }
        format.js { render :create, layout: 'modal_create' }
      end
    else
      render :new
    end
  end

  # just a forward action so that a GET to /kontakt works
  def index
    redirect_to :new_contact
  end
end
