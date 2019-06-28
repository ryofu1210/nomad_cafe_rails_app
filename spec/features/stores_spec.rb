require 'rails_helper'

RSpec.feature "Stores", type: :feature do
  scenario "ユーザは新しいStoreを投稿する" do
    user = FactoryBot.create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect {
      click_link "投稿"
      fill_in name:"store[name]", with: "TEST Name"
      select "1", from: "store[long_stay]"
      select "あり", from: "store[consent]"
      select "あり", from: "store[wifi]"
      click_button "保存"
    }.to change(user.stores, :count).by(1)
  end
end
