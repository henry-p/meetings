class MeetingsController < ApplicationController
  def new
  	@meeting = Meeting.new
  end

  def create
  	@event = Meeting.new(title: params[:meeting][:title])
  	respond_to do |format|
  		if @event.save
  			event = {
  				'summary' => @event.title,
  				'location' => 'Chinatown',
  				'start' => {
  					'dateTime' => '2011-06-03T10:00:00.000-07:00'
  				},
  				'end' => {
  					'dateTime' => '2014-11-11T11:00:00.000-07:00'
  				},
  				'attendess' => [ { 'email' => 'joe.timmer@loringindustries.com' } ]
  			}
  			# define user token here
  			token = session[:token]
  			client = Google::APIClient.new
  			client.authorization.access_token = token
  			service = client.discovered_api('calendar', 'v3')
  			result = client.execute(:api_method => service.events.insert,
  															:parameters => {'calendarId' => 'primary' },
  															:body => JSON.dump(event),
  															:headers => { 'Content-Type' => 'application/json' } )
  			format.html { redirect_to root_path, notice: 'Event was successfully created.' }
  			format.json { render json: @event, status: :created, location: @event }
  		else
				format.html { render action: "new" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
  end
end
