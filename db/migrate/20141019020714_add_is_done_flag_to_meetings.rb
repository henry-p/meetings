class AddIsDoneFlagToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :is_done, :boolean, default: false
  end
end
