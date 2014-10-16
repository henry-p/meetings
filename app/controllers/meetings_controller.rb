class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def create
    # @meeting = Meeting.new(meeting_params) # ...
    raise
  end

  private

  def meeting_params
    params.require(:meeting).permit(:title, :location, :start, :end)
  end
end
