class StoresController < ApplicationController
  skip_before_action :authenticate_user!, only:%w(index show title_update)
  before_action :set_parameter, only:%w(index)
  before_action :correct_user, only:%w(edit update destroy)
  ITEMS_PER_PAGE = 6

  def index
    stores = Store.search(@parameters[:search])
    # stores = stores.favorite(current_user) if @parameters[:type] == "favorite_stores"
    stores = current_user.favorite_stores.search(@parameters[:search]) if @parameters[:type] == "favorite_stores"
    @stores = stores.page(@parameters[:page]).per(ITEMS_PER_PAGE)
  end

  def title_update
    # debugger
    @title = params[:title]
  end

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = current_user.stores.new(store_params)
    if @store.save
      flash[:notice] = "登録が完了しました。"
      redirect_to stores_path
    else
      # debugger
      flash[:alert] = "登録が失敗しました。"
      render action: :new
    end
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find_by(id: params[:id])
    if @store.update(store_params)
      flash[:notice] = "更新が完了しました。"
      redirect_to stores_path
    else
      flash[:alert] = "更新が失敗しました。"
      render action: :edit
    end
  end

  def destroy
    @store = Store.find(params[:id])
    if @store.update(status: 1)
      flash[:notice] = "削除が完了しました。"
      redirect_to stores_path
    else
      flash[:alert] = "削除が失敗しました。"
      render action: :index
    end
  end

  private
  def set_parameter
    @parameters = params.slice(:search, :page, :type).reject{|_, value| value.blank?}
  end

  def store_params
    params.require(:store).permit(
      :name,
      :long_stay,
      :consent,
      :wifi,
      :wifi_description,
      :comment,
      :image
    )
  end

  def correct_user
    @store = Store.find_by(id:params[:id])
    unless @store.user == current_user
      flash[:alert] = "権限がありません"
      redirect_to root_path
    end
  end

end
