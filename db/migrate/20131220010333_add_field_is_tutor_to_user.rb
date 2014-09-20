class AddFieldIsTutorToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_tutor?, :boolean, :default => true
  end
end
