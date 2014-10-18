class MeetingsController < ApplicationController
  def new
    @meeting = Meeting.new
  end

  def contacts
    contacts = $redis.get(current_user.id)
    respond_to do |format|
      format.json { render json: contacts }
    end
  end

  def create
    raise
    params[:meeting][:start_time] = DateTime.strptime(params[:meeting][:start_time], '%m/%d/%Y %H:%M %P')
    params[:meeting][:end_time] = DateTime.strptime(params[:meeting][:end_time], '%m/%d/%Y %H:%M %P')

    @event = Meeting.new(meeting_params)
    if @event.save
      current_user.create_event(Meeting.event_hash(@event))
      redirect_to root_path
    else
      render 'meetings/new'
    end
  end

  private

  def meeting_params
    params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes)
  end
end
