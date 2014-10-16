class AgendaTopic < ActiveRecord::Base
  belongs_to :creator, class_name: "User"

  has_many :votes

  belongs_to :meeting

  has_one :conclusion
end
