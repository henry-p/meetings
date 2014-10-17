class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def create
    # @meeting = Meeting.new(meeting_params) # ...
    raise
  end

  def create
  	@event = Meeting.new(meeting_params)
		if @event.save
			@event.start_time = @event.start_time.in_time_zone(@event.time_zone)
    	@event.end_time = @event.end_time.in_time_zone(@event.time_zone)
			current_user.create_event(Meeting.event_hash(@event))
			puts "---------------event_hash-----------------------"
			puts "---------------event_hash-----------------------"
			puts "---------------event_hash-----------------------"
			puts @event.start_time.to_datetime
			puts "---------------event_hash-----------------------"
			puts "---------------event_hash-----------------------"
			puts "---------------event_hash-----------------------"

			redirect_to root_path
		else
			render 'meetings/new'
		end
  end

  private
	def meeting_params
		params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes)
	end
end
