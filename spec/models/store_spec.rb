require 'rails_helper'

RSpec.describe Store, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  before do
    # @user = FactoryBot.create(:user)
    @store = FactoryBot.create(:store)
  end

  describe "Validation" do
    context "正常系" do
      it "有効なSTOREの検証" do
        expect(@store).to be_valid
      end
    end

    context "異常系" do
      it "nameの存在性検証" do
        @store.name = ""
        expect(@store).not_to be_valid
      end

      it "nameの最大長さ検証" do
        @store.name = "a"*101
        expect(@store).not_to be_valid
      end

      it "user_idの存在性検証" do
        @store.user_id = ""
        expect(@store).not_to be_valid
      end

      it "long_stayの存在性検証" do
        @store.long_stay = nil
        expect(@store).not_to be_valid
      end

      it "consentの存在性検証" do
        @store.consent = nil
        expect(@store).not_to be_valid
      end

      it "wifiの存在性検証" do
        @store.wifi = nil
        expect(@store).not_to be_valid
      end

      it "wifi_descriptionの最大長さ検証" do
        @store.wifi_description = "a"*201
        expect(@store).not_to be_valid
      end

      it "commentの最大長さ検証" do
        @store.comment = "a"*201
        expect(@store).not_to be_valid
      end

      it "statusの存在性検証" do
        @store.status = nil
        expect(@store).not_to be_valid
      end
    end
  end

  describe "#search" do
    before do
      @storeA = FactoryBot.create(:store,name:"nameA", comment:"commentA")
      @storeB = FactoryBot.create(:store,name:"nameB", comment:"commentB")
      @storeC = FactoryBot.create(:store,name:"nameC", comment:"commentC")
    end

    context "引数がないとき" do
      it "全件返ってくる" do
        expect(Store.search()).to include(@storeA,@storeB,@storeC)
      end
    end

    context "マッチするStoreが見つかったとき" do
      it "検索結果にマッチしたStoreが返ってくる" do
        expect(Store.search("C")).to include(@storeC)
        expect(Store.search("C")).not_to include(@storeA,@storeB)
      end
    end
      
    context "マッチするStoreが見つからなかったとき" do
      it "空の配列が返ってくる" do
        expect(Store.search("No Match")).to be_empty
      end
    end
  end

end
