class UsersController < ApplicationController
  def profile
    puts params[:id].blank?
    redirect_to root_path and return if params[:id].blank?

    @user = User.find params[:id]
  end
end
