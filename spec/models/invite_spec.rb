require 'spec_helper'

describe Invite do
  describe "Associations" do
    let(:invite) { Invite.new }

    it "should belong to an invitee" do
      expect(invite).to belong_to(:invitee)
    end

    it "should belong to a meeting" do
      expect(invite).to belong_to(:meeting)
    end
  end

  describe "#self.create_invites" do
    it "should create a meeting and assign attendees to it" do
      creator = User.create!(email: "creator@test.com")
      meeting = Meeting.create!(title: "Title", description: "Description", location: "Location", start_time: Time.now, end_time: Time.now + 3600, time_zone: "Hawaii", notes: "Note", creator_id: creator.id)
      Invite.create_invites(creator, "attendee1@test.com,attendee2@test.com", meeting)

      invitee1 = User.find_by_email("attendee1@test.com")
      invitee2 = User.find_by_email("attendee2@test.com")
      expect(meeting.invitees).to eq([invitee1, invitee2])
    end
  end
end