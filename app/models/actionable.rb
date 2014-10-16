class Actionable < ActiveRecord::Base
  has_many :responsibilities
  has_many :creators, through: :responsibilities, source: :user

  belongs_to :meeting
end
