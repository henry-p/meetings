class MeetingsController < ApplicationController
  def new
<<<<<<< HEAD
    @meeting = Meeting.new
  end

  def create
    # @meeting = Meeting.new(meeting_params) # ...
    raise
  end

  def contacts
    contacts = $redis.get(current_user.id)
    respond_to do |format|
      format.json { render json: contacts }
    end    
  end

  private

  def meeting_params
    params.require(:meeting).permit(:title, :location, :start, :end)
=======
  	@meeting = Meeting.new
  end

  def create
  	@event = Meeting.new(title: params[:meeting][:title])
  	respond_to do |format|
  		if @event.save
  			event = {
  				'summary' => @event.title,
  				'location' => 'Chinatown',
  				'description' => "It will be so cooool!",
  				'source' => { 
  					'title' => "Jimmy Joe", 
  					'url' => "http://jtimmer89.github.io"
  				},
  				'start' => {
  					'dateTime' => '2014-11-10T10:00:00.000-07:00',
  				},
  				'end' => {
  					'dateTime' => '2014-11-11T11:00:00.000-07:00'
  				},
  				'attendees' => [ { 'email' => 'isaacnoda@gmail.com' } ]
  			}

  			current_user.create_event(event)

  			format.html { redirect_to root_path, notice: 'Event was successfully created.' }
  			format.json { render json: @event, status: :created, location: @event }
  		else
				format.html { render action: "new" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
>>>>>>> ff7bfe6a1ce46170b54ec6bf17705b677ed7dd1a
  end
end
