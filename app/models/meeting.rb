class Meeting < ActiveRecord::Base
  has_many :invites
  has_many :invitees, through: :invites, source: :user

  belongs_to :creator, class_name: "User"

  has_many :actionables

  has_many :agenda_topics
end
