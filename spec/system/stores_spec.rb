require 'rails_helper'

RSpec.describe 'Stores', type: :system do
  # before do
  #   @user = FactoryBot.create(:user)
  # end

  it 'ユーザがStoreを投稿して成功する' do
    user = FactoryBot.create(:user)
    visit root_path
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect {
      click_link "投稿"
      # fill_in name:"store[name]", with: "TEST Name"
      sleep 1
      save_and_open_page
      fill_in "TENPOMEI", with: "TEST NAME"
      select "1", from: "store[long_stay]"
      select "あり", from: "store[consent]"
      select "あり", from: "store[wifi]"
      attach_file "store[image]", "#{Rails.root}/spec/files/store_image.jpg"
      click_button "保存"
    }.to change(user.stores, :count).by(1)
  end
end