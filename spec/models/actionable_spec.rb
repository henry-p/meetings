require 'spec_helper'

describe Actionable do
  describe "Associations" do
    let(:actionable) { Actionable.new }

    it "should belong to one creator" do
      expect(actionable).to belong_to(:creator)
    end

    it "should have many responsible users" do
      expect(actionable).to have_many(:responsible_users)
    end

    it "should belong to a meeting" do
      expect(actionable).to belong_to(:meeting)
    end
  end

  describe "Validations" do
    it { should validate_presence_of(:content) }  
    it { should validate_presence_of(:creator_id) }
    it { should validate_presence_of(:meeting_id) }    
  end  
end