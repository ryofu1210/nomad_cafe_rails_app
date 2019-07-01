require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @store = FactoryBot.create(:store, user: @other_user)
  end

  describe "#create" do
    context "ログイン時" do
      it "他人投稿のStoreのとき、favorite登録に成功する" do
        sign_in @user
        expect {post :create, xhr: true, params:{id:@user.id, store_id:@store.id
          }}.to change(Favorite.all,:count).by(1)
        # expect { xhr :post, :create, params:{id:@user.id, store_id:@store.id}
        #   }.to change(Favorite.all,:count).by(1)
      end
      it "自分投稿のStoreのとき、favorite登録に成功する" do
        sign_in @other_user
        expect {post :create,xhr: true, params:{id:@other_user.id, store_id:@store.id
          }}.to change(Favorite.all,:count).by(1)
      end

    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        expect{post :create, xhr:true, params:{id:@user.id, store_id:@store.id
        }}.to change(Favorite.all,:count).by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#destroy" do
    before do
      @favorite = FactoryBot.create(:favorite,user:@user, store:@store)
    end
    context "ログイン時" do
      it "favorite削除に成功する" do
        sign_in @user
        expect {delete :destroy, xhr: true, params:{id:@user.id,store_id:@store.id
          }}.to change(Favorite.all,:count).by(-1)
      end

      it "他人のfavoriteの削除に失敗する" do
        sign_in @other_user
        expect {delete :destroy, xhr: true, params:{id:@user.id,store_id:@store.id
          }}.to change(Favorite.all,:count).by(0)
      end
    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        expect {delete :destroy, xhr: true, params:{id:@user.id,store_id:@store.id
        }}.to change(Favorite.all,:count).by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
