class User < ActiveRecord::Base
  has_many :responsibilities
  has_many :actionables, through: :responsibilities

  has_many :votes, foreign_key: :voter_id

  has_many :invites, foreign_key: :invitee_id
  has_many :meetings, through: :invites

  has_many :meetings, foreign_key: :creator_id

  has_many :agenda_topics, foreign_key: :creator_id

  has_many :voted_agenda_topics, through: :votes, source: :agenda_topic
end
