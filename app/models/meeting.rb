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
    (self.end - self.start) / 3600
  end
end