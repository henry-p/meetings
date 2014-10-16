require 'spec_helper'

describe User do
  describe "Associations" do
    let(:user) { User.new }

    it "should be responsible for many actionables" do
      expect(user).to have_many(:assigned_actionables)
    end

    it "should have many meetings as a creator" do
      expect(user).to have_many(:meetings).with_foreign_key(:creator_id)
    end

    it "should have many meetings as an invitee" do
      expect(user).to have_many(:meetings)
    end

    it "should have many votes" do
      expect(user).to have_many(:votes)
    end

    it "should have many agenda topics as creator" do
      expect(user).to have_many(:agenda_topics).with_foreign_key(:creator_id)
    end

    it "should have many agenda topics as a voter" do
      expect(user).to have_many(:voted_agenda_topics)
    end
  end
end