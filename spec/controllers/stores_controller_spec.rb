require 'rails_helper'

RSpec.describe StoresController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @store = FactoryBot.create(:store, user: @user)
  end

  describe "#index" do
    context "ログイン時" do
      it "Store一覧ページが表示される" do
        sign_in @user
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログイン時" do
      it "Store一覧ページが表示される" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "#show" do
    context "ログイン時" do
      it "Store詳細ページが表示される" do
        sign_in @user
        get :show, params:{id: @store.id}
        expect(response).to have_http_status(:success)
      end
    end
    
    context "非ログイン時" do
      it "Store詳細ページが表示される" do
        get :show, params:{id: @store.id}
        expect(response).to have_http_status(:success)
      end
    end
  end
  
  describe "#new" do
    context "ログイン時" do
      it "Store新規登録ページが表示される" do
        sign_in @user
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe "#create" do
    context "ログイン時" do
      it "Store登録に成功する" do
        store_params = FactoryBot.attributes_for(:store)
        sign_in @user
        expect {post :create, params:{store: store_params
          }}.to change(Store.all,:count).by(1)  
      end

      it "無効な値を入力するとStore登録に失敗する" do
        store_params = FactoryBot.attributes_for(:store, name:nil)
        sign_in @user
        expect {post :create, params:{store: store_params
          }}.to change(Store.all,:count).by(0)  
      end
    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        store_params = FactoryBot.attributes_for(:store)
        expect{post :create, params:{store: @store_params
        }}.to change(Store.all,:count).by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  
  describe "#edit" do
    context "ログイン時" do
      it "自分投稿のStoreの時、Store編集ページが表示される" do
        sign_in @user
        get :edit, params:{id:@store.id}
        expect(response).to have_http_status(:success)
      end

      it "他人投稿のStoreの時、Store一覧ページにリダイレクトされる" do
        sign_in @user
        store = FactoryBot.create(:store)
        get :edit, params:{id:store.id}
        expect(response).not_to have_http_status(:success)
        expect(response).to redirect_to root_path
      end
    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        get :edit, params:{id:@store.id}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe "#update" do
    context "ログイン時" do
      it "自分投稿のStoreの時、Store更新に成功し、Store一覧ページにリダイレクトされる" do
        store_params = FactoryBot.attributes_for(:store, name:"New Name")
        sign_in @user
        patch :update, params:{id:@store.id, store:store_params}
        expect(@store.reload.name).to eq "New Name" 
        expect(response).to redirect_to stores_path
      end

      it "自分投稿のStoreの時、無効な値を入力するとStore登録に失敗する" do
        store_params = FactoryBot.attributes_for(:store, name:nil)
        sign_in @user
        patch :update, params:{id:@store.id, store:store_params}
        expect(@store.reload.name).to eq "name"
      end


      it "他人投稿のStoreの時、Store更新に失敗し、ルートページにリダイレクトされる" do
        store = FactoryBot.create(:store)
        store_params = FactoryBot.attributes_for(:store, name:"New Name")
        sign_in @user
        patch :update, params:{id:store.id, store:store_params}
        expect(store.reload.name).not_to eq "New Name" 
        expect(response).to redirect_to root_path
      end
    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        store_params = FactoryBot.attributes_for(:store, name:"New Name")
        patch :update, params:{id:@store.id, store: store_params}
        expect(@store.reload.name).not_to eq "New Name" 
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "#destroy" do
    context "ログイン時" do
      it "自分投稿のStoreの時、Storeの論理削除に成功する" do
        sign_in @user
        expect {delete :destroy, params:{id: @store.id}
          }.to change(Store.all,:count).by(0)
        expect(@store.reload.status).to eq 1
      end

      it "他人投稿のStoreの時、Store削除に失敗し、ルートページにリダイレクトされる" do
        store = FactoryBot.create(:store)
        sign_in @user
        expect{delete :destroy, params:{id:store.id}
          }.to change(Store.all,:count).by(0) 
        expect(response).to redirect_to root_path
      end

    end

    context "非ログイン時" do
      it "ログインページへリダイレクトされる" do
        expect{delete :destroy, params:{id: @store.id}
          }.to change(Store.all,:count).by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
