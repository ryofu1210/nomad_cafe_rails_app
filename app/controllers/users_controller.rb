class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  ITEMS_PER_PAGE = 6

  def show
    @user = User.find(params[:id])
    @stores = @user.stores.active.sorted.page(params[:page]).per(ITEMS_PER_PAGE)
  end
end
