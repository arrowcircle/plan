class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :articul, null: false
      t.string :type
      t.integer :account_id, null: false, index: true
      t.integer :category_id, index: true
      t.integer :position

      t.timestamps null: false
    end
    add_index :items, [:type, :id]
  end
end
