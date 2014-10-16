class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :invitee_id
      t.integer :meeting_id

      t.timestamps
    end
  end
end
