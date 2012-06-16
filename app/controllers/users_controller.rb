class UsersController < ApplicationController
  def profile
    puts params[:id].blank?

    @user = User.find params[:id]
  end
end
