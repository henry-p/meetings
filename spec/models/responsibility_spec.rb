require 'spec_helper'

describe Responsibility do
  describe "Associations" do
    let(:responsibility) { Responsibility.new }

    it "should belong to a user" do
      expect(responsibility).to belong_to(:user)
    end

    it "should belong to an actionable" do
      expect(responsibility).to belong_to(:actionable)
    end
  end
end