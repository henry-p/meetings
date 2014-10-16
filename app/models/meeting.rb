class Meeting < ActiveRecord::Base
  has_many :invites
  has_many :invitees, through: :invites

  belongs_to :creator, class_name: "User"

  has_many :actionables

  has_many :agenda_topics

  def self.event_hash(event)
  	{ 'summary' => event.title,
			'location' => event.location,
			'description' => event.invite_notes,
			'start' => { 'dateTime' => event.start_time, 'timeZone' => event.timezone },
			'end' => { 'dateTime' => event.end_time },
			'attendees' => event.invitees_array
		}
  end

  def invite_notes
  	"#{self.description} \nlocalhost:3000/meetings/#{self.id}"
  end

  def invitees_array
  	self.invitees.map { |invitee| emails_array << { 'email' => invitee.email } }
  end
end
