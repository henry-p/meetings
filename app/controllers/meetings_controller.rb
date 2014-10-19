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
    @meeting = Meeting.find_by_id(params[:id])
    if logged_in?
      if current_user != @meeting.creator
        unless @meeting.invitees.include?(current_user)
          flash[:error] = "You don't have access to this meeting."
          redirect_to profile_path
        end
      end
    else
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
  	if Meeting.empty_datetime(params)
  		@meeting = Meeting.new(meeting_params_without_time)
  		flash.now[:error] = "Please give a start and end time to create an event."
  		render :new
  	elsif Meeting.empty_title(params)
  		@meeting = Meeting.new(meeting_params)
  		flash.now[:error] = "Please include a title to create an event."
  		render :new
  	else
	  	@meeting = Meeting.new(meeting_params.merge(creator: current_user))
	  	Invite.create_invites(params[:attendees], @meeting)
			response = current_user.create_event(Meeting.event_hash(@meeting))
			if response.status == 200
				@meeting.update(calendar_event_id: response.data.id)
				redirect_to root_path, flash: { success: "Your event was successfully created." }
			else
				@meeting.invites.destroy_all
				flash.now[:error] = "Google was not able to create your event. Please try again."
				render :new
			end
		end
  end

  def edit
  	@meeting = Meeting.find_by_id(params[:id])
  end

  def update
  	if Meeting.empty_datetime(params)
  		@meeting = Meeting.new(meeting_params_without_time)
  		flash.now[:error] = "Please give a start and end time to edit an event."
  		render :edit
  	elsif Meeting.empty_title(params)
  		@meeting = Meeting.new(meeting_params)
  		flash.now[:error] = "Please include a title to edit an event."
  		render :edit
  	else
	  	@meeting = Meeting.find_by_id(params[:id])
	  	@meeting.invites.destroy_all
	  	Invite.create_invites(params[:attendees], @meeting)
	  	unsaved_event = @meeting.clone
	  	response = current_user.update_event(Meeting.event_hash(unsaved_event), @meeting.calendar_event_id)
	  	if response.status == 200
	  		@meeting.update(meeting_params)
	  		redirect_to root_path, flash: { success: "Your event was successfully edited." }
	  	else
	  		@meeting.invites.destroy_all
				flash.now[:error] = "Google was not able to update your event. Please try again."
				render :edit
	  	end
	  end
  end

  def destroy
  	@meeting = Meeting.find_by_id(params[:id])
  	response = current_user.delete_event(@meeting.calendar_event_id)
  	if response.status == 204
  		@meeting.destroy 
  		redirect_to root_path, flash: { success: "Your event was successfully deleted." }
  	else
  		redirect_to root_path, flash: { error: "Google was not able to delete your event. Please try again." }
  	end
  end

  private
  
	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end

	def meeting_params_without_time
		if params[:meeting][:start_time].empty? && params[:meeting][:end_time].empty?
			params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes)
		elsif params[:meeting][:start_time].empty?
			Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :end_time, :time_zone, :notes))
		else params[:meeting][:end_time].empty?
			Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :time_zone, :notes))
		end
	end
end
