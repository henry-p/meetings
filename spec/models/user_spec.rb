require 'spec_helper'

describe User do
  let(:user) { User.new }

  it "should have many actionables" do
    expect(user).to have_many :actionables
  end
end