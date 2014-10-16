require 'spec_helper'

describe Vote do
  describe "Associations" do
    let(:vote) { Vote.new }

    it "should belong to a voter" do
      expect(vote).to belong_to(:voter)
    end

    it "should belong to an agenda topic" do
      expect(vote).to belong_to(:agenda_topic)
    end
  end
end