class AddPlanIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :plan_id, :integer, index: true
  end
end
