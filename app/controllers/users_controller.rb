class UsersController < ApplicationController
  def show
    @meetings = current_user.meetings
  end

  def contacts
    contacts = current_user.load_contacts_from_redis
    respond_to do |format|
      format.json { render json: contacts }
    end
  end
end