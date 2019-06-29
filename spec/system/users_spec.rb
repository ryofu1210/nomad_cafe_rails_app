require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "ログイン機能" do
    before do
      @user = FactoryBot.create(:user, email: "test@example.com", password: "password", password_confirmation:"password")
      visit new_user_session_path
    end

    context "有効な値を入力したとき" do
      it 'ログインに成功し、ルートページにリダイレクトされる' do
        fill_in "メールアドレス", with:@user.email
        fill_in "パスワード", with:@user.password
        click_button "ログイン"
        expect(page).to have_css "div.bg-success.notice"
        expect(find("h2")).to have_content("カフェ一覧")
      end
    end

    context "無効な値を入力したとき" do
      it 'メールアドレスが無効' do
        fill_in "メールアドレス", with:""
        fill_in "パスワード", with:@user.password
        click_button "ログイン"
        expect(page).to have_css "div.bg-success.alert"
        expect(find("h2")).to have_content("ログイン")
      end

      it 'パスワードが無効' do
        fill_in "メールアドレス", with:@user.email
        fill_in "パスワード", with:""
        click_button "ログイン"
        expect(page).to have_css "div.bg-success.alert"
        expect(find("h2")).to have_content("ログイン")
      end
    end
  end

  describe "サインアップ機能" do
    before do
      visit new_user_registration_path
    end

    context "有効な値を入力したとき" do
      it "サインアップに成功し、ルートページにリダイレクトされる" do
        fill_in "メールアドレス", with:"test@example.com"
        fill_in "パスワード", with:"password"
        fill_in "パスワード確認", with:"password"
        click_button "新規登録"
        expect(page).to have_css("div.bg-success.notice")
      end
    end

    context "無効な値を入力したとき" do
      it "メールアドレスが無効" do
        fill_in "メールアドレス", with:"aaaaaaaaaa"
        fill_in "パスワード", with:"password"
        fill_in "パスワード確認", with:"password"
        click_button "新規登録"
        expect(find("h2.title")).to have_content("新規登録")        
      end

      it "パスワードが無効" do
        fill_in "メールアドレス", with:"test@example.com"
        fill_in "パスワード", with:"pass"
        fill_in "パスワード確認", with:"pass"
        click_button "新規登録"
        expect(find("h2.title")).to have_content("新規登録")        
      end

      it "パスワードとパスワード確認が不一致" do
        fill_in "メールアドレス", with:"test@example.com"
        fill_in "パスワード", with:"password"
        fill_in "パスワード確認", with:"abcdefg"
        click_button "新規登録"
        expect(find("h2.title")).to have_content("新規登録")
      end

    end
  end

  # describe "ログアウト機能" do
  #   before do
  #     @user = FactoryBot.create(:user, email: "test@example.com", password: "password", password_confirmation:"password")
  #     sign_in @user
  #     visit root_path
  #   end

  #   it "ログアウトに成功する" do
  #     click_link "ログアウト"

  #   end
  # end

  describe "ユーザ更新機能" do
    before do
      @user = FactoryBot.create(:user, email: "test@example.com", password: "password", password_confirmation:"password")
      sign_in @user
      visit edit_user_registration_path
    end

    context "有効な値を入力したとき" do
      it 'ユーザ情報の更新に成功する' do
        fill_in "メールアドレス", with:"update@example.com"
        fill_in "ニックネーム", with:"ニックネーム"
        fill_in "プロフィール", with:"プロフィール"
        attach_file "写真を選択","#{Rails.root}/spec/files/user_image.png"
        click_button "更新"
        expect(page).to have_css "div.bg-success.notice"
        expect(find("h2")).to have_content("カフェ一覧")
      end
    end

    context "無効な値を入力したとき" do
      it '更新に失敗する' do
        fill_in "メールアドレス", with:""
        fill_in "ニックネーム", with:"ニックネーム"
        fill_in "プロフィール", with:"プロフィール"
        attach_file "写真を選択","#{Rails.root}/spec/files/user_image.png"
        click_button "更新"
        # expect(page).to have_css "div.bg-success.alert"
        expect(page).to have_content("ユーザ情報を変更")
      end
    end
  end

  describe "ユーザ詳細表示機能" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
      sign_in @user
    end

    context "カレントユーザから見たとき" do
      before do
        visit user_path(@user)
      end

      it "編集リンクが表示される" do
        expect(find(".User")).to have_link("編集", href:edit_user_registration_path)
      end

      it "ユーザ名が表示される" do
        expect(page).to have_content(@user.nickname)
        expect(page).not_to have_content(@other_user.nickname)
      end
    end

    context "他のユーザのページを見たとき" do
      before do
        visit user_path(@other_user)
      end

      it "編集リンクが表示されない" do
        expect(find(".User")).not_to have_link("編集", href:edit_user_registration_path)
      end

      it "ユーザ名が表示される" do
        expect(page).to have_content(@other_user.nickname)
        expect(page).not_to have_content(@user.nickname)
      end
    end
  end

end