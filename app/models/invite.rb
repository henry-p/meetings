class Invite < ActiveRecord::Base
  belongs_to :invitee, class_name: "User"
  belongs_to :meeting

  def self.create_invites(attendees, event)
  	if attendees.nil?
  	else
	  	attendees.split(",").each do |email|
	  		user = User.find_or_create_by(email: CanonicalEmails::GMail.transform(email).address.downcase)
	  		event.invites.create!(invitee_id: user.id)
	  	end
	  end
  end
end
