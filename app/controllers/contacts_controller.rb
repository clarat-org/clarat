# frozen_string_literal: true
# Contact and report form
class ContactsController < ApplicationController
  respond_to :html, :js

  def new
    @contact = Contact.new url: request.referer
    respond_with @contact
  end

  def create
    referer = request.referer || '/'
    @contact = Contact.new params.for(Contact).refine
    if @contact.save
      respond_to do |format|
        format.html do
          redirect_to referer, flash: { success: t('.success') }
        end
        format.js { render :create, layout: 'modal_create' }
      end
    else
      validation_fail_render
    end
  end

  # just a forward action so that a GET to /kontakt works
  def index
    redirect_to :new_contact
  end

  private

  def validation_fail_render
    if params[:contact][:message].eql? t('layouts.partials.modal.popup.message')
      render :popup
    else
      render :new
    end
  end
end
