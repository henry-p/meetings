class Meeting < ActiveRecord::Base
	after_save :apply_time_zone

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

  def apply_time_zone
    self.start_time = self.start_time.in_time_zone(self.time_zone)
    self.end_time = end_time.in_time_zone(self.time_zone)
  end
end
