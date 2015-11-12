class DefinitionsController < ApplicationController
  respond_to :js, :html
  layout false

  skip_before_action :authenticate_user!

  def show
    @definition = Definition.find params[:id]
    authorize @definition
    respond_with @definition
  end
end
