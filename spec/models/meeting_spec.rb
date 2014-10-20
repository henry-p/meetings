require 'spec_helper'

describe Meeting do
  describe "Associations" do
    let(:meeting) { Meeting.new }

    it "should belong to a creator" do
      expect(meeting).to belong_to(:creator)
    end

    it "should have many invitees" do
      expect(meeting).to have_many(:invitees)
    end

    it "should have many actionables" do
      expect(meeting).to have_many(:actionables)
    end

    it "should have many agenda topics" do
      expect(meeting).to have_many(:agenda_topics)
    end
  end

  describe "Validations" do
    it { should validate_presence_of(:creator_id) } 
    it { should validate_presence_of(:title) } 
  end

  describe "Methods" do
    
  end
end

