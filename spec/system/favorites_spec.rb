require 'rails_helper'

RSpec.describe 'Favorites', type: :system do


  describe "お気に入り登録機能" , js:true do
    before do
      @user = FactoryBot.create(:user)
      @store = FactoryBot.create(:store, name: "FAVO_STORE")
      sign_in @user
      visit root_path
    end

    it "お気に入り登録に成功し、お気に入りSTORE一覧に表示される" do
      expect{
        click_link nil, href: store_favorites_path(@store)
        # save_and_open_page  
        sleep(1)
      }.to change(Favorite.all, :count).by(1)
      
      find('#FAVORITE').click
      expect(page).to have_content("FAVO_STORE")
    end
  end

  describe "お気に入り削除機能", js:true  do
    before do
      @user = FactoryBot.create(:user)
      @store = FactoryBot.create(:store, name: "FAVO_STORE")
      FactoryBot.create(:favorite, user: @user, store: @store)
      sign_in @user
      visit root_path
    end

    it "お気に入り削除に成功し、お気に入りSTORE一覧に表示されない" do
      # save_and_open_page
      expect{
        click_link nil, href: store_favorite_path(store_id:@store.id, id:@user.id)
        sleep(1)
      }.to change(Favorite.all, :count).by(-1)

      find('#FAVORITE').click
      expect(page).not_to have_content("FAVO_STORE")
    end
  end


end