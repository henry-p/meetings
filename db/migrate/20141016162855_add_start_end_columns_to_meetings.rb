class AddStartEndColumnsToMeetings < ActiveRecord::Migration
  def change
  	add_column :meetings, :start, :datetime
  	add_column :meetings, :end, :datetime
  end
end
