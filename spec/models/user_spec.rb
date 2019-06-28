require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  before do
    @user = FactoryBot.create(:user)
  end

  context "正常系" do
    it "有効なUserの検証" do
      expect(@user).to be_valid
    end
  end

  context "異常系" do
    it "emailの存在性" do
      @user.email = ""
      expect(@user).not_to be_valid
    end

    it "emailの一意性" do
      user = FactoryBot.build(:user, email:"testtest@example.com")
      expect(user).not_to be_valid
    end

    it "emailのフォーマット" do
      @user.email = "ABC"
      expect(@user).not_to be_valid
    end

    it "nicknameの最大長さ" do
      @user.nickname = "a"*51
      expect(@user).not_to be_valid
    end

    it "プロフィールの最大長さ" do
      @user.nickname = "a"*201
      expect(@user).not_to be_valid
    end

    it "パスワードの存在性" do
      @user.password = ""
      expect(@user).not_to be_valid
    end

    it "パスワードの最小長さ" do
      @user.password = "a"*5
      expect(@user).not_to be_valid
    end
  end
end
