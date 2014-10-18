class AgendaTopic < ActiveRecord::Base
  belongs_to :creator, class_name: "User"

  has_many :votes

  belongs_to :meeting

  has_one :conclusion

  validates :content, :meeting_id, :creator_id, presence: true
end
