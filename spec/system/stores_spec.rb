require 'rails_helper'

RSpec.describe 'Stores', type: :system do


  describe "Store投稿機能" do
    before do
      @user = FactoryBot.create(:user)
      sign_in @user
      visit new_store_path
    end

    context "有効なデータを送信した時" do
      it 'Storeの新規登録に成功する' do
        expect {
          fill_in "店舗名", with: "TEST NAME"
          select "1", from: "長居しやすさ度"
          select "あり", from: "コンセント有無"
          select "あり", from: "Wifi有無"
          attach_file "写真を選択", "#{Rails.root}/spec/files/store_image.jpg"
          click_button "保存"

          expect(page).to have_css "div.bg-success.notice"
          expect(page).to have_content("TEST NAME")
        }.to change(@user.stores, :count).by(1)
      end
    end

    context "無効なデータを送信した時" do
      it 'Storeの新規登録に失敗する' do
        expect {
          fill_in "店舗名", with: ""
          select "1", from: "長居しやすさ度"
          select "あり", from: "コンセント有無"
          select "あり", from: "Wifi有無"
          attach_file "写真を選択", "#{Rails.root}/spec/files/store_image.jpg"
          click_button "保存"

          expect(page).to have_css "div.bg-success.alert"
        }.to change(@user.stores, :count).by(0)
      end
    end
  end

  describe "Store更新機能" do
    before do
      @user = FactoryBot.create(:user)
      @store = FactoryBot.create(:store, user: @user)
      sign_in @user
      visit edit_store_path(@store)
    end

    context "有効なデータを送信した時" do
      it 'Storeの更新に成功する' do
        fill_in "店舗名", with: "UPDATE NAME"
        click_button "保存"
        expect(page).to have_css "div.bg-success.notice"
        expect(page).to have_content("UPDATE NAME")
      end
    end

    context "無効なデータを送信した時" do
      it 'Storeの更新に失敗する' do
        fill_in "店舗名", with: ""
        click_button "保存"
        expect(page).to have_css "div.bg-success.alert"
      end
    end
  end

  describe "Store削除機能" do
    before do
      @user = FactoryBot.create(:user)
      @store = FactoryBot.create(:store, name: "TEST STORE",user: @user)
      sign_in @user
      visit stores_path
    end

    it 'Storeが削除される' do
      expect {
        expect(page).to have_content("TEST STORE")
        click_link "削除"
        expect(page).to have_css "div.bg-success.notice"
        expect(page).not_to have_content("TEST NAME")
      }.to change(Store.all, :count).by(0) #論理削除なのでDBの件数は変わらない
    end
  end

  describe "Store一覧表示機能" do
    before do
      @user = FactoryBot.create(:user)
      @store1 = FactoryBot.create(:store, name: "STORE1",user: @user)
      @store2 = FactoryBot.create(:store, name: "STORE2")
      @deleted_store = FactoryBot.create(:store, name: "DELETE STORE", status: 1)
      sign_in @user
    end

    it "有効なStoreのみが一覧で表示され、削除済みStoreは表示されない" do
      visit stores_path
      expect(page).to have_content "STORE1"
      expect(page).to have_content "STORE2"
      expect(page).not_to have_content "DELETE STORE"
    end
  end

  describe "Store詳細表示機能" do
    before do
      @user = FactoryBot.create(:user)
      @store = FactoryBot.create(:store, name: "MY STORE",user: @user)
      @other_store = FactoryBot.create(:store, name: "OTHER STORE")
      sign_in @user
    end

    context "自分の投稿を見た時" do
      it "編集・削除リンクが表示される" do
        visit store_path(@store)
        expect(page).to have_link("編集", href: edit_store_path(@store))
        expect(page).to have_link("削除", href: store_path(@store))
      end
    end

    context "他人の投稿を見た時" do
      it "編集・削除リンクが表示されない" do
        visit store_path(@other_store)
        expect(page).not_to have_link("編集", href: edit_store_path(@other_store))
        expect(page).not_to have_link("削除", href: store_path(@other_store))
      end
    end
  end

  describe "Store検索機能" do
    before do
      @store1 = FactoryBot.create(:store, name: "STORE1", comment:"COMMENT A")
      @store2 = FactoryBot.create(:store, name: "STORE2", comment:"COMMENT B")
      @store3 = FactoryBot.create(:store, name: "STORE3", comment:"COMMENT C")
      visit stores_path
    end

    it "指定されたキーワードを含むNAME、COMMENTのSTORE一覧が表示される" do
      fill_in name:"search", with:"1"
      click_button "検索"
      expect(page).to have_content("STORE1")
      expect(page).not_to have_content("STORE2")
      expect(page).not_to have_content("STORE3")
    end
  end

  describe "お気に入りSTORE一覧表示機能" do
    before do
      @user = FactoryBot.create(:user)
      @favo_store1 = FactoryBot.create(:store, name: "FAVO_STORE1", user:@user)
      @favo_store2 = FactoryBot.create(:store, name: "FAVO_STORE2", user:@user)
      @not_favo_store = FactoryBot.create(:store, name: "NOT_FAVO_STORE", user:@user)
      @other_store = FactoryBot.create(:store, name: "OTHER_STORE3")
      FactoryBot.create(:favorite, user:@user, store:@favo_store1)
      FactoryBot.create(:favorite, user:@user, store:@favo_store2)
      sign_in @user
      visit stores_path
    end

    it "ユーザがお気に入り登録しているSTOREのみが一覧表示される" do
      find('#FAVORITE').click
      expect(page).to have_content("FAVO_STORE1")
      expect(page).to have_content("FAVO_STORE2")
      expect(page).not_to have_content("NOT_FAVO_STORE")
      expect(page).not_to have_content("OTHER_STORE")
    end

    it "ユーザがお気に入りSTORE一覧表示後、指定キーワード検索でSTORE一覧の絞り込みができる" do
      find('#FAVORITE').click
      expect(page).to have_content("FAVO_STORE1")
      expect(page).to have_content("FAVO_STORE2")
      expect(page).not_to have_content("NOT_FAVO_STORE")
      expect(page).not_to have_content("OTHER_STORE")

      fill_in name:"search", with:"1"
      click_button "検索"
      expect(page).to have_content("FAVO_STORE1")
      expect(page).not_to have_content("FAVO_STORE2")
      expect(page).not_to have_content("NOT_FAVO_STORE")
      expect(page).not_to have_content("OTHER_STORE")
    end

    it "ユーザが指定キーワード検索でSTORE一覧表示後、お気に入りSTORE一覧表示で、STORE一覧の絞り込みができる" do
      fill_in name:"search", with:"FAVO"
      click_button "検索"
      expect(page).to have_content("FAVO_STORE1")
      expect(page).to have_content("FAVO_STORE2")
      expect(page).to have_content("NOT_FAVO_STORE")
      expect(page).not_to have_content("OTHER_STORE")

      find('#FAVORITE').click
      expect(page).to have_content("FAVO_STORE1")
      expect(page).to have_content("FAVO_STORE2")
      expect(page).not_to have_content("NOT_FAVO_STORE")
      expect(page).not_to have_content("OTHER_STORE")
    end


  end



end