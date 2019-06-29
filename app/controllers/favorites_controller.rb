class FavoritesController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    @favorite = current_user.favorites.new(store_id: params[:store_id])
    if @favorite.save
      flash[:notice] = "お気に入り登録が完了しました。"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "お気に入り登録が失敗しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @favorite = Favorite.find_by(store_id: params[:store_id], user_id: params[:id])
    @favorite.destroy
    flash[:notice] = "お気に入りから外しました。"
    redirect_back(fallback_location: root_path)
  end

  private

  def correct_user
    favorite = Favorite.find_by(user_id:params[:id],store_id:params[:store_id])
    unless favorite.user == current_user
      flash[:alert] = "権限がありません"
      redirect_back(fallback_location: root_path)
    end
  end
end
