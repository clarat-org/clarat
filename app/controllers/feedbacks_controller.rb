# Feedback and report form to get in contact with the website publisher
class FeedbacksController < ApplicationController
  respond_to :html, :js

  skip_before_action :authenticate_user!, only: [:new, :create, :index]

  def new
    authorize Feedback.new
    present Feedback::Create
    # @feedback = Feedback.new url: request.referrer
    # respond_with @feedback
  end

  def create
    authorize Feedback.new
    run Feedback::Create do |_operation|
      return redirect_to root_path, flash: { success: t('.success') }
    end

    render :new
  end
  #   @feedback = Feedback.new params.for(Feedback).refine
  #   authorize @feedback
  #   if @feedback.save
  #     respond_to do |format|
  #       format.html do
  #         redirect_to root_path, flash: { success: t('.success') }
  #       end
  #       format.js { render :create, layout: 'modal_create' }
  #     end
  #   else
  #     render :new
  #   end
  # end

  # just a forward action so that a GET to /kontakt works
  def index
    redirect_to :new_feedback
  end
end
