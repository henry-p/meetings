class AddIndices < ActiveRecord::Migration
  def change
    add_index(:users, :email)
    add_index(:users, [:last_name, :first_name])
    add_index(:responsibilities, :actionable_id)
    add_index(:responsibilities, :user_id)
    add_index(:actionables, :meeting_id)
    add_index(:actionables, :creator_id)
    add_index(:votes, :agenda_topic_id)
    add_index(:votes, :voter_id)
    add_index(:invites, :invitee_id)
    add_index(:invites, :meeting_id)
    add_index(:meetings, :creator_id)
    add_index(:meetings, :scheduled_date)
    add_index(:agenda_topics, :creator_id)
    add_index(:agenda_topics, :meeting_id)
    add_index(:conclusions, :agenda_topic_id)
  end
end
