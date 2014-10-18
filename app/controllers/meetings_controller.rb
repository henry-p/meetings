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
		if @event.save
  		Invite.create_invites(params[:attendees], @event)
			response = current_user.create_event(Meeting.event_hash(@event))
			if response.status == 200
				redirect_to root_path
			else
				render 'meetings/new'
			end
		else
			render 'meetings/new'
		end
  end

  def edit
  	@meeting = Meeting.find_by_id(params[:id])
  end

  def update
  	@event = Meeting.find_by_id(params[:id])
  	if @event.update(meeting_params)
  		unless @event.calendar_event_id.nil?
  			@event.invites.destroy_all
  			Invite.create_invites(params[:attendees], @event)
  			current_user.update_event(Meeting.event_hash(@event), @event.calendar_event_id)
  			redirect_to root_path
  		end
  	else
  		render 'meetings/edit'
  	end
  end

  def destroy
  	@event = Meeting.find_by_id(params[:id])
  	@event.destroy
  	if @event.destroyed?
  		unless @event.calendar_event_id.nil?
  			current_user.delete_event(@event.calendar_event_id)
  		end
  	end
  	redirect_to root_path
  end

  private
  
	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end
end
