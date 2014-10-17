class Meeting < ActiveRecord::Base
	# before_validation :string_to_datetime

  has_many :invites
  has_many :invitees, through: :invites
  belongs_to :creator, class_name: "User"
  has_many :actionables
  has_many :agenda_topics

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
  	"#{self.description} \nlocalhost:3000/meetings/#{self.id}"
  end

  def invitees_array
  	self.invitees.map { |invitee| emails_array << { 'email' => invitee.email } }
  end

  def self.strings_to_datetime(start_time, end_time)
  	start_time = DateTime.strptime(start_time, '%m/%d/%Y %H:%M')
  	end_time = DateTime.strptime(end_time, '%m/%d/%Y %H:%M')
  end
end
