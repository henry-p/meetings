require 'spec_helper'

describe SendGridWorker do
  describe "perform" do
    it "takes a meeting" do
      SendGridWorker.perform_async(1)
    end
  end
end