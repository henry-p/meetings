class CreateAgendaTopics < ActiveRecord::Migration
  def change
    create_table :agenda_topics do |t|
      t.integer :user_id
      t.integer :meeting_id
      t.text :content

      t.timestamps
    end
  end
end
