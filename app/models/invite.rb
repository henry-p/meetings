class Invite < ActiveRecord::Base
  belongs_to :invitee, class_name: "User"
  belongs_to :meeting

  def self.create_invites(creator, attendees, meeting)
    if attendees.nil?
    else
      all_contacts = creator.load_contacts_from_redis
      attendees.split(",").each do |email|
        email = CanonicalEmails::GMail.transform(email).address.downcase
        contact = all_contacts.detect { |c| c["email"] == email }
        if contact && contact["full_name"]
          names = contact["full_name"].split(" ")
          first_name = names[0...-1] ? names[0...-1].join(" ") : "no"
          last_name = names[-1] ? names[-1] : "name"
        end
        contact = {first_name: first_name, last_name: last_name, email: email}
        user = User.find_or_create_by(contact)
        meeting.invites.create!(invitee_id: user.id)
      end
    end
  end
end
