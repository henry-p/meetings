require 'spec_helper'

describe Conclusion do
  describe "Associations" do
    let(:conclusion) { Conclusion.new }

    it "should belong to an agenda topic" do
      expect(conclusion).to belong_to(:agenda_topic)
    end
  end
end