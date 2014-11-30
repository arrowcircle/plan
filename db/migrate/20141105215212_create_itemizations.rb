class CreateItemizations < ActiveRecord::Migration
  def change
    create_table :itemizations do |t|
      t.integer :item_id, index: true
      t.integer :parent_id, index: true
      t.integer :quantity
      t.integer :account_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
