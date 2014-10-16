class CreateConclusions < ActiveRecord::Migration
  def change
    create_table :conclusions do |t|
      t.integer :agenda_topic_id
      t.text :content

      t.timestamps
    end
  end
end
