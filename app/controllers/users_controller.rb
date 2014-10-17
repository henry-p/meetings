class UsersController < ApplicationController
  def show
    @meetings = current_user.meetings
  end
end