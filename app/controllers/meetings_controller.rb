class MeetingsController < ApplicationController
include ActionView::Helpers::SanitizeHelper
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
		if @event.save
  		Invite.create_invites(params[:attendees], @event)
			current_user.create_event(Meeting.event_hash(@event))
			redirect_to root_path
		else
			render 'meetings/new'
		end
  end

  def update_notes
    @meeting = Meeting.find_by_id(params[:id])
    notes = params[:notes]
    p notes
    notes.gsub!(/(<br>|<p>|<div>)/, "\n")
    notes = strip_tags(notes)
    notes.strip!
    notes.gsub!(/(\n+\s*){3,}/, "\n\n")
    p notes
    @meeting.update_attributes(notes: notes)
    render 'update_notes'
  end

  private
  
	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end
end
