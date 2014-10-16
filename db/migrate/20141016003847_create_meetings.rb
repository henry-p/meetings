class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :creator_id
      t.string :title
      t.string :description
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.string :time_zone
      t.text :notes

      t.timestamps
    end
  end
end
