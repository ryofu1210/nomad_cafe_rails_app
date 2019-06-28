require 'rails_helper'

RSpec.describe Favorite, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @favorite = FactoryBot.create(:favorite)
  end

  describe "Validation" do
    context "正常系" do
      it "Favoriteが有効であるとき" do
        expect(@favorite).to be_valid
      end
    end

    context "異常系" do
      it "user_idの存在性検証" do
        @favorite.user_id = nil
        expect(@favorite).not_to be_valid
      end

      it "store_idの存在性検証" do
        @favorite.store_id = nil
        expect(@favorite).not_to be_valid
      end

      it "store_idとuser_idの一意性検証" do
        favorite = FactoryBot.build(:favorite, user_id:@favorite.user_id, store_id:@favorite.store_id)
        expect(favorite).not_to be_valid
      end
    end
  end
end
