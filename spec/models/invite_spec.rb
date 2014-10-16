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
end