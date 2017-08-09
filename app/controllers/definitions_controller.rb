# frozen_string_literal: true
class DefinitionsController < ApplicationController
  respond_to :js, :html
  layout false

  def show
    @definition = Definition.find params[:id]
    respond_with @definition
  end
end
