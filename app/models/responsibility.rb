class Responsibility < ActiveRecord::Base
  belongs_to :user
  belongs_to :actionable

  validates :user_id, uniqueness: {scope: :actionable_id}
end