class RemoveScheduledDateFromMeetings < ActiveRecord::Migration
	def change
		remove_column  :meetings, :scheduled_date
	end
end
