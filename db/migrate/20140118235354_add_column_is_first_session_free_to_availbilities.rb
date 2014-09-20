class AddColumnIsFirstSessionFreeToAvailbilities < ActiveRecord::Migration
  def change
    add_column :availabilities, :is_first_session_free, :boolean, :default => false
  end
end
