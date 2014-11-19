class CreateItemizations < ActiveRecord::Migration
  def change
    create_table :itemizations do |t|
      t.integer :item_id, index: true
      t.integer :parent_id, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
