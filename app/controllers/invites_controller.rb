class InvitesController < ApplicationController
	def destroy
		@meeting = Meeting.find_by_id(params[:meeting_id])
		response = current_user.delete_event(@meeting.calendar_event_id)
		if google_api_call_success?(response) || google_api_call_404(response)
			Invite.find_by_id(params[:id]).destroy
			redirect_to root_path, flash: { success: "You successfully removed yourself from the event." }
		else
			redirect_to root_path, flash: { error: "Google was not able to delete you from the event. Please try again." }
		end
	end
end
