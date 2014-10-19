class AddDefaultToMeetingNotes < ActiveRecord::Migration
  def change
    change_column :meetings, :notes, :text, default: ""
  end
end
