class AddImageToStore < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :image, :string
  end
end
