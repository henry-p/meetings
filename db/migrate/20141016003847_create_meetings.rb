class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :creator_id
      t.string :title
      t.string :location
      t.date :scheduled_date
      t.text :notes

      t.timestamps
    end
  end
end
