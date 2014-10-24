class UsersController < ApplicationController
  respond_to :html

  def show
    @user = User.find params[:id]
    authorize @user
    respond_with @user
  end
end
