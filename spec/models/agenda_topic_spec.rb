require 'spec_helper'

describe AgendaTopic do
  describe "Associations" do
    let(:agenda_topic) { AgendaTopic.new }

    it "should have many votes" do
      expect(agenda_topic).to have_many(:votes)
    end

    it "should belong_to a creator" do
      expect(agenda_topic).to belong_to(:creator)
    end

    it "should belong to a meeting" do
      expect(agenda_topic).to belong_to(:meeting)
    end

    it "should have one conclusion" do
      expect(agenda_topic).to have_one(:conclusion)
    end
  end

  describe "Validations" do
    it { should validate_presence_of(:content) }  
    it { should validate_presence_of(:creator_id) }
    it { should validate_presence_of(:meeting_id) }    
  end
end