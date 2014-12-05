class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, null: :false
      t.integer :owner_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
