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
  	@event = Meeting.new(meeting_params.merge(creator: current_user))
  	Invite.create_invites(params[:attendees], @event)
		response = current_user.create_event(Meeting.event_hash(@event))
		if response.status == 200
			@event.update(calendar_event_id: response.data.id)
			redirect_to root_path
		else
			@event.invites.destroy_all
			render 'meetings/new'
		end
  end

  def edit
  	@meeting = Meeting.find_by_id(params[:id])
  end

  def update
  	@event = Meeting.find_by_id(params[:id])
  	@event.invites.destroy_all
  	Invite.create_invites(params[:attendees], @event)
  	unsaved_event = @event.clone
  	response = current_user.update_event(Meeting.event_hash(unsaved_event), @event.calendar_event_id)
  	if response.status == 200
  		@event.update(meeting_params)
  		redirect_to root_path
  	else
  		render 'meetings/edit'
  	end
  end

  def destroy
  	@event = Meeting.find_by_id(params[:id])
  	response = current_user.delete_event(@event.calendar_event_id)
  	@event.destroy if response.status == 204
  	redirect_to root_path
  end

  private
  
	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end
end
