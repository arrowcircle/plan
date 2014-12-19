class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :status
      t.integer :account_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
