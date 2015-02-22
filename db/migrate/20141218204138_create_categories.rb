class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :account_id, index: true
      t.string :type
      t.string :ancestry, index: true
      t.integer :position

      t.timestamps null: false
    end
    add_index :categories, [:type, :id]
  end
end
