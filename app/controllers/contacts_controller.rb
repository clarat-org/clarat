class ContactsController < ApplicationController
  respond_to :html

  skip_before_action :authenticate_user!, only: [:new, :create, :index]

  def new
    @contact = Contact.new url: request.referrer
    authorize @contact
    respond_with @contact
  end

  def create
    @contact = Contact.new params.for(Contact).refine
    authorize @contact
    if @contact.save
      redirect_to root_path, flash: {
        success: I18n.t('flash.contact.success')
      }
    else
      render :new
    end
  end

  # just a forward action so that a GET to /kontakt works
  def index
    redirect_to :new_contact
  end
end
