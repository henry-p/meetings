class Meeting < ActiveRecord::Base
  has_many :invites
  has_many :invitees, through: :invites
  belongs_to :creator, class_name: "User"
  has_many :actionables
  has_many :agenda_topics

  validates :creator_id, presence: true
  validates :title, presence: true

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
			'start' => { 'dateTime' => event.start_time.to_datetime.strftime("%FT%T"), 'timeZone' => event.to_google_time_zone },
			'end' => { 'dateTime' => event.end_time.to_datetime.strftime("%FT%T"), 'timeZone' => event.to_google_time_zone },
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

  def email_array_for_mailer
    self.invitees.map { |invitee| invitee.email } + [self.creator.email]
  end

  def self.format_params(meeting_params)
  	meeting_params[:start_time] = DateTime.strptime(meeting_params[:start_time], '%m/%d/%Y %H:%M %P') if !meeting_params[:start_time].nil?
  	meeting_params[:end_time] = DateTime.strptime(meeting_params[:end_time], '%m/%d/%Y %H:%M %P') if !meeting_params[:end_time].nil?
  	meeting_params
  end

  def self.empty_datetime(params)
  	params[:meeting][:start_time].empty? || params[:meeting][:end_time].empty?
  end

  def self.empty_title(params)
  	params[:meeting][:title].empty?
  end

  def to_google_time_zone
  	case self.time_zone
  	when "Hawaii"
  		return "Pacific/Honolulu"
  	when "Alaska"
  		return "America/Anchorage"
  	when "Pacific Time (US & Canada)"
  		return "America/Los_Angeles"
  	when "Arizona"
  		return "America/Phoenix"
  	when "Mountain Time (US & Canada)"
  		return "America/Denver"
  	when "Central Time (US & Canada)"
  		return "America/Chicago"
  	when "Eastern Time (US & Canada)"
  		return "America/New_York"
  	when "Indiana (East)"
  		return "America/Indiana/Indianapolis"
  	else
  		return "America/Chicago"
  	end
  end

  def format_to_local_time(utc_time)
  	utc_time.strftime('%m/%d/%Y %I:%M %p') if !utc_time.nil?
  end
end
