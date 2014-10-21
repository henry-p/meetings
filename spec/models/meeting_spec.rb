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
    let(:good_meeting) { Meeting.new(title: "Testing conference", start_time: Time.now, end_time: Time.now) }
    let(:bad_meeting) { Meeting.new(title: '') }

    describe "#empty_title?" do
      it "returns true if meeting does not have a title" do
        expect(bad_meeting.empty_title?).to eq true
        expect(Meeting.new.empty_title?).to eq true
      end

      it "returns false if meeting has a title" do
        expect(good_meeting.empty_title?).to eq false
      end
    end

    describe "#empty_datetime?" do
      it "returns false if a meeting has a start and end time" do
        expect(good_meeting.empty_datetime?).to eq false
      end

      it "returns true if a meeting does not have a start and end time" do
        expect(bad_meeting.empty_datetime?).to eq true
        expect(Meeting.new(start_time: Time.now).empty_datetime?).to eq true
        expect(Meeting.new(end_time: Time.now).empty_datetime?).to eq true
      end     
    end         
  end
end




