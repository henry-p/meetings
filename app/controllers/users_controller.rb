class UsersController < ApplicationController
  def show
    @meetings = current_user.meetings
  end

  def contacts
    contacts = $redis.get(current_user.id)
    respond_to do |format|
      format.json { render json: contacts }
    end
  end
end