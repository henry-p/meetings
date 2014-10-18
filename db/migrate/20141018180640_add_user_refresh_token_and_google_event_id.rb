class AddUserRefreshTokenAndGoogleEventId < ActiveRecord::Migration
  def change
    add_column :users, :refresh_token, :string
    add_column :meetings, :calendar_event_id, :string
  end
end
