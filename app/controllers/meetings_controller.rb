class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def contacts
    contacts = $redis.get(current_user.id)
    respond_to do |format|
      format.json { render json: contacts }
    end
  end

  def show
    @meeting = Meeting.find_by_id(params[:id])
  end

  def create
  	if params[:meeting][:start_time].empty? || params[:meeting][:end_time].empty?
  		redirect_to new_meeting_path, flash: { error: "Please give a start and end time to create an event." }
  	else
	  	@meeting = Meeting.new(meeting_params.merge(creator: current_user))
	  	Invite.create_invites(params[:attendees], @meeting)
			response = current_user.create_event(Meeting.event_hash(@meeting))
			if response.status == 200
				@meeting.update(calendar_event_id: response.data.id)
				redirect_to root_path, flash: { success: "Your event was successfully created." }
			else
				@meeting.invites.destroy_all
				redirect_to new_meeting_path, flash: { error: "Google was not able to create your event. Please try again." }
			end
		end
  end

  def edit
  	@meeting = Meeting.find_by_id(params[:id])
  end

  def update
  	if params[:meeting][:start_time].empty? || params[:meeting][:end_time].empty?
  		redirect_to edit_meeting_path, flash: { error: "Please give a start and end time to edit an event." }
  	else
	  	@meeting = Meeting.find_by_id(params[:id])
	  	@meeting.invites.destroy_all
	  	Invite.create_invites(params[:attendees], @meeting)
	  	unsaved_event = @meeting.clone
	  	response = current_user.update_event(Meeting.event_hash(unsaved_event), @meeting.calendar_event_id)
	  	if response.status == 200
	  		@meeting.update(meeting_params)
	  		redirect_to root_path, flash: { success: "Your event was successfully edited." }
	  	else
	  		redirect_to edit_meeting_path, flash: { error: "Google was not able to update your event. Please try again." }
	  	end
	  end
  end

  def destroy
  	@meeting = Meeting.find_by_id(params[:id])
  	response = current_user.delete_event(@meeting.calendar_event_id)
  	if response.status == 204
  		@meeting.destroy 
  		redirect_to root_path, flash: { success: "Your event was successfully deleted." }
  	else
  		redirect_to root_path, flash: { error: "Google was not able to delete your event. Please try again." }
  	end
  end

  private
  
	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end
end
