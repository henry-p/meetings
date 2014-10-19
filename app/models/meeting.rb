class Meeting < ActiveRecord::Base
  has_many :invites
  has_many :invitees, through: :invites
  belongs_to :creator, class_name: "User"
  has_many :actionables
  has_many :agenda_topics

  def self.format_timestamp(datetime)
    datetime.strftime('%A - %b %d, %Y (%l:%M %p)')
  end

  def duration
    (self.end_time - self.start_time) / 3600
  end


  def self.event_hash(event)
  	{ 'summary' => event.title,
			'location' => event.location,
			'description' => event.invite_notes,
			'start' => { 'dateTime' => event.start_time.to_datetime.strftime("%FT%T"), 'timeZone' => event.time_zone },
			'end' => { 'dateTime' => event.end_time.to_datetime.strftime("%FT%T"), 'timeZone' => event.time_zone },
			'attendees' => event.invitees_array
		}
  end

  def invite_notes
  	"#{self.description} \n\nlocalhost:3000/meetings/#{self.id}"
  end

  def invitees_array
  	emails_array = []
  	self.invitees.map { |invitee| emails_array << { 'email' => invitee.email } }
  	emails_array
  end

  def self.format_params(meeting_params)
  	meeting_params[:start_time] = DateTime.strptime(meeting_params[:start_time], '%m/%d/%Y %H:%M %P')
  	meeting_params[:end_time] = DateTime.strptime(meeting_params[:end_time], '%m/%d/%Y %H:%M %P')
  	meeting_params
  end
end
