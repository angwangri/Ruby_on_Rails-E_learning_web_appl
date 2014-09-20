class AddPerStudentRateToAvailabilities < ActiveRecord::Migration
  def change
  	add_column :availabilities, :two_students, :text
  	add_column :availabilities, :three_plus_students, :text
  end
end
