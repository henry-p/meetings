class Actionable < ActiveRecord::Base
  has_many :responsibilities
  has_many :responsible_users, through: :responsibilities, source: :user

  belongs_to :creator, class_name: "User"

  belongs_to :meeting
end
