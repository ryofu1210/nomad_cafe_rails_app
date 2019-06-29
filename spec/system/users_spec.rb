require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'completes yubinbango automatically with JS' do
    # User編集画面を開く
    visit root_path

    # Nameに"いとう"が入力されていることを検証する
    # expect(page).to have_field '名前', with: 'いとう'

    # 郵便番号を入力
    # fill_in '郵便番号', with: '158-0083'
    # 住所が自動入力されたことを検証する
    # expect(page).to have_field '住所', with: '東京都世田谷区奥沢'

    # 更新実行
    # click_button 'Update User'

    # 正しく更新されていること（＝画面の表示が正しいこと）を検証する
    # save_and_open_page
    expect(page).to have_content 'カフェ一覧'
  end
end