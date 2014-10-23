class AddIsLiveFlagToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :is_live, :boolean
  end
end
