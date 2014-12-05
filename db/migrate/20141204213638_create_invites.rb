class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :account_id, null: false, index: true
      t.string :email, null: false
      t.string :token, null: false, uniq: true, index: true
      t.integer :user_id, index: true
      t.timestamp :activated_at

      t.timestamps null: false
    end
  end
end
