class MeetingsController < ApplicationController
  def new
  	@meeting = Meeting.new
  end

  def create
  	@event = Meeting.new(params[:meeting])
  	respond_to do |format|
  		if @event.save
  			current_user.create_event(Meeting.event_hash(@event))

  			format.html { redirect_to root_path, notice: 'Event was successfully created.' }
  			format.json { render json: @event, status: :created, location: @event }
  		else
				format.html { render action: "new" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
  end
end
