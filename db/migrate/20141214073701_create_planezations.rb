class CreatePlanezations < ActiveRecord::Migration
  def change
    create_table :planezations do |t|
      t.integer :plan_id, index: true
      t.integer :item_id, index: true
      t.float :quantity
      t.integer :account_id, null: false, index: true
      t.timestamps null: false
    end
  end
end
