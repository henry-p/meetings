require 'spec_helper'

describe Meeting do
  describe "Associations" do
    let(:meeting) { Meeting.new }

    it "should belong to a creator" do
      expect(meeting).to belong_to(:creator)
    end

    it "should have many invites" do
      expect(meeting).to have_many(:invites)
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
    before(:each) do
      Sidekiq::Worker.clear_all
    end

    let(:good_meeting) { Meeting.new(title: "Testing conference", start_time: Time.now, end_time: Time.now + 60, description: "Test") }
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

    describe "#empty_datetime?" do
      it "returns the description and link of the event" do
        id = good_meeting.id
        expect(good_meeting.invite_notes).to eq "Test \n\nhttp:/meetingz.herokuapp.com/meetings/#{id}"
      end
    end

    describe "#start" do
      it "sets is_live to true" do
        expect(good_meeting.is_live).to eq nil
        good_meeting.start
        expect(good_meeting.is_live).to eq true
      end
    end

    describe "#truncated_title" do
      it "returns the truncated title if it's more than 13 chars" do
        expect(good_meeting.truncated_title).to eq 'Testing confer...'
      end

      it "returns the full title if it's less than 13 chars" do
        good_meeting.update(title: "Shorted")
        expect(good_meeting.truncated_title).to eq 'Shorted'
      end
    end

    describe "#close_meeting_and_send_email" do
      it "closes the meeting and calls on the SendGridWorker" do
        expect(SendGridWorker).to receive(:perform_async)
        expect(good_meeting.is_done).to eq false
        good_meeting.close_meeting_and_send_email
        expect(good_meeting.is_live).to eq false
        expect(good_meeting.is_done).to eq true
      end
    end

    describe "#just_the_date" do
      it "formats the date with day, month, and year" do
        expect(good_meeting.just_the_date).to match(/(\w+ - \w+ \d{2}, \d{4})/)
      end
    end

    describe "Meeting#format_timestamp" do
      it "formats the date with day, month, year, and time" do
        expect(Meeting.format_timestamp(Time.now)).to match(/(\w+ - \w+ \d{2}, \d{4} \W \d{1,2}:\d{2} \w{2}\W)/)
      end
    end
  end
end

# just_the_date


