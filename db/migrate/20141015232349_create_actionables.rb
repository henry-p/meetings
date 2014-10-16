class CreateActionables < ActiveRecord::Migration
  def change
    create_table :actionables do |t|
      t.integer :meeting_id
      t.integer :creator_id
      t.text :content

      t.timestamps
    end
  end
end
