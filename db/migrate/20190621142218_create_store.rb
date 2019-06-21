class CreateStore < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.integer :long_stay, null: false #長時間居やすさ
      t.boolean :consent, null: false #コンセントの有無
      t.boolean :wifi, null: false #wifi有無
      t.text :wifi_description #wifi詳細
      t.text :comment #コメント
      t.references :user, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
