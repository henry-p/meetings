class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def create
  	@event = Meeting.new(meeting_params)
		if @event.save
  		Invite.create_invites(params[:attendees], @event)
			current_user.create_event(Meeting.event_hash(@event))
			redirect_to root_path
		else
			render 'meetings/new'
		end
  end

  private
	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end
end
