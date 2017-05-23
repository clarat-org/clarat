# frozen_string_literal: true
# Contact and report form
class ContactsController < ApplicationController
  respond_to :html, :js

  def new
    @contact = Contact.new url: request.referer
    respond_with @contact
  end

  def create
    @contact = Contact.new params.for(Contact).refine
    if @contact.save
      respond_to do |format|
        format.html do
          redirect_to section_choice_path, flash: { success: t('.success') }
        end
        format.js { render :create, layout: 'modal_create' }
      end
    else
      if params[:contact][:message].eql? "Ich möchte an der Umfrage teilnehmen"
        render :popup
      else
        render :new
      end
    end
  end

  def popup
    @contact = Contact.new
  end

  # just a forward action so that a GET to /kontakt works
  def index
    redirect_to :new_contact
  end
end
