class MeetingsController < ApplicationController
  skip_before_action :require_login, only: [:show, :check_invited]
  before_filter(only: [:update, :destroy]) { |filter| filter.check_if_meeting_is_closed(params[:id]) }

  def new
    @meeting = Meeting.new
  end

  def contacts
    contacts = $redis.get(current_user.id)
    respond_to do |format|
      format.json { render json: contacts }
    end
  end

  def show
    if logged_in?
      @meeting = Meeting.find_by_id(params[:id])
    else
      @meeting = Meeting.find_by_id(params[:id])
      render :invited
    end
  end

  def check_invited
    @meeting = Meeting.find_by_id(params[:meeting_id])
    @invitee_emails = @meeting.invitees.pluck(:email)

    if @invitee_emails.include?(params[:email])
      session[:user_id] = User.find_by_email(params[:email]).id
      render :show
    else
      flash[:error] = "This email address is not on the list of the people invited to this meeting."
      render :invited
    end
  end

  def create
    @event = Meeting.new(meeting_params.merge(creator: current_user))
    if @event.save
      Invite.create_invites(params[:attendees], @event)
      current_user.create_event(Meeting.event_hash(@event))
      redirect_to root_path
    else
      render 'meetings/new'
    end
  end

  private

  def meeting_params
    Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
  end
end
