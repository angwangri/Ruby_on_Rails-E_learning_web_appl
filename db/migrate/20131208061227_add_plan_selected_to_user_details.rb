class AddPlanSelectedToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :is_plan_selected?, :boolean, :default => false
  end
end
