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
      expect(user).to have_many(:invited_meetings)
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

  describe "Validations" do
    it { should validate_presence_of(:email) }  
    it { should validate_uniqueness_of(:email) }  
  end  

  describe "#token_expires_soon?" do
    user = User.new(token_expires_at: 1413675332) # 6:35

    it "returns true if a tokens expiration is less than 30 minutes away" do
      its_6_45 = Time.local(2014, 10, 18, 18, 45, 0)
      Timecop.freeze(its_6_45)
      expect(user.token_expires_soon?).to eq true
    end

    it "returns false if a tokens expiration is more than 30 minutes away" do
      its_4_45 = Time.local(2014, 10, 18, 16, 45, 0)
      Timecop.freeze(its_4_45)
      expect(user.token_expires_soon?).to eq false
    end
  end

  describe "#oauth2_client" do
    user = User.new

    it 'creates an oath2 client object' do
      expect(user.oauth2_client).to be_a OAuth2::Client
    end
  end

  describe "#oauth2_token_object" do
    user = User.new

    it 'creates an oath2 token object' do
      expect(user.oauth2_token_object).to be_a OAuth2::AccessToken
    end
  end  

  describe "#google_api_client" do
    user = User.new

    it 'creates a google api client object' do
      expect(user.google_api_client).to be_a Google::APIClient
    end
  end   

  describe "#full_name_or_email" do
    it 'returns the full name if possible' do
      user = User.new(first_name: "Isaac", last_name: "Noda")
      expect(user.full_name_or_email).to eq "Isaac Noda"
    end

    it 'returns the email if full name is not possible' do
      user = User.new(first_name: "Isaac", email: "isaacnoda@yahoo.com")
      expect(user.full_name_or_email).to eq "isaacnoda@yahoo.com"
    end
  end    

  describe "#full_name" do 
    it 'returns the full name if possible' do
      user = User.new(first_name: "Isaac", last_name: "Noda")
      expect(user.full_name).to eq "Isaac Noda"      
    end

    it 'returns nil if not possible' do
      user = User.new()
      expect(user.full_name).to eq nil
    end
  end
end