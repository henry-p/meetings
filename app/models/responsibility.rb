class Responsibility < ActiveRecord::Base
  belongs_to :user
  belongs_to :actionable
end
