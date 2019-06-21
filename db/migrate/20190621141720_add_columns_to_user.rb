class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nickname, :string, null: false, default: ""
    add_column :users, :profile, :text
    add_column :users, :image, :string
  end
end
