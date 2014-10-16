class HomeController < ApplicationController
  def index
    if logged_in?
      redirect_to profile_path
    end
  end
end