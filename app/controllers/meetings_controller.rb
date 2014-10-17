class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def create
    # @meeting = Meeting.new(meeting_params) # ...
    raise
  end

  def contacts
    contacts = $redis.get(current_user.id)
    respond_to do |format|
      format.json { render json: contacts }
    end    
  end

  private

  def meeting_params
    params.require(:meeting).permit(:title, :location, :start, :end)
  end
end
