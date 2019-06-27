class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
    @stores = @user.stores.active.sorted.page(params[:page]).per(1)
  end
end
