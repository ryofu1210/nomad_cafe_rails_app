require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
  end
  describe "#show" do
    context "ログイン時" do
      it "ユーザ詳細ページが表示される" do
        sign_in @user
        get :show, params: {id: @user.id}
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログイン時" do
      it "ユーザ詳細ページが表示される" do
        get :show, params: {id: @user.id}
        expect(response).to have_http_status(:success)
      end
    end
  end
end
