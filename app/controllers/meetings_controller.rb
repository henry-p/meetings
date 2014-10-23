class MeetingsController < ApplicationController
	skip_before_action :require_login, only: [:show, :check_invited]
	before_filter(only: [:update, :destroy]) { |filter| filter.check_if_meeting_is_closed(params[:id]) }
	before_filter :find_meeting_by_id, only: [:show, :edit, :destroy, :update_notes]
	include ActionView::Helpers::SanitizeHelper

	def new
		@time_zone = Meeting.to_rails_time_zone(cookies["time_zone"])
		id = params[:id]
		if id
			previous_meeting = Meeting.find_by_id(id)

			unless previous_meeting
				redirect_to profile_path and return
			end

			if previous_meeting.creator == current_user || previous_meeting.invitees.include?(current_user)
				local_time = Time.now
				@meeting = previous_meeting.dup
				@meeting.invitees = previous_meeting.invitees
				day_after_meeting = previous_meeting.start_time + 86400
				start_time = day_after_meeting < local_time ? local_time : day_after_meeting
				end_time = start_time + previous_meeting.duration_in_seconds
				@meeting.assign_attributes(start_time: start_time, end_time: end_time)
			else
				@meeting = Meeting.new
			end
		else
			@meeting = Meeting.new
		end
	end

	def show
		@showing_meeting = true
		if logged_in?
			if current_user.email.downcase != @meeting.creator.email.downcase
				@invitee_emails = @meeting.invitees.pluck(:email).map(&:downcase)
				unless @invitee_emails.include?(current_user.email.downcase)
					flash[:error] = "You don't have access to this meeting."
					redirect_to profile_path
				end
			end
		else
			render :invited
		end
	end

	def attendees
		@meeting = Meeting.find(params[:meeting_id])
		@invitees = @meeting.invitees
		contact_data = @invitees.map do |invitee|
			{ full_name: invitee.full_name, email: invitee.email }
		end
		respond_to do |format|
			format.json { render json: contact_data }
		end
	end

	def check_invited
		@meeting = Meeting.find_by_id(params[:meeting_id])
		@invitee_emails = @meeting.invitees.pluck(:email).map(&:downcase)

		if @invitee_emails.include?(params[:email].downcase)
			session[:user_id] = User.find_by_email(params[:email].downcase).id
			render :show
		else
			flash[:error] = "This email address is not associated with any of this meeting's members."
			render :invited
		end
	end

	def create
		@meeting = Meeting.new(meeting_params.merge(creator: current_user))

		if @meeting.empty_datetime? || @meeting.empty_title?
			flash.now[:error] = "A meeting must have a title, start time, and end time."
			return render :new
		end

		if @meeting.save
			Invite.create_invites(current_user, params[:attendees], @meeting)
		else
			flash.now[:error] = "There was an error processing your request. Please try again."
			return render :new
		end

		response = current_user.create_event(Meeting.event_hash(@meeting))
		if google_api_call_success?(response)
			@meeting.update(calendar_event_id: response.data.id)
			redirect_to root_path, flash: { success: "Your event was successfully created." }
		else
			@meeting.destroy_self_and_invites
			flash.now[:error] = "Google was not able to create your event. Please try again."
			render :new
		end
	end

	def edit
	end

	def update
		@time_zone = @meeting.time_zone

		if params[:close]
			@meeting.close_meeting_and_send_email
			return redirect_to profile_archive_path
		end

		if params[:start]
			@meeting.start
			return redirect_to meeting_path(@meeting)
		end

		unsaved_event = @meeting.clone # we only update the db if google calendar gets updated

		response = current_user.update_event(Meeting.event_hash(unsaved_event), @meeting.calendar_event_id)
		if google_api_call_success?(response)
			@meeting.update(meeting_params)
			@meeting.invites.destroy_all
			Invite.create_invites(current_user, params[:attendees], @meeting)
			redirect_to root_path, flash: { success: "Your event was successfully edited." }
		else
			flash.now[:error] = "Google was not able to update your event. Please try again."
			render :edit
		end
	end

	def destroy
		response = current_user.delete_event(@meeting.calendar_event_id)
		if google_api_call_success?(response) || google_api_call_404(response)
			@meeting.destroy_self_and_invites
			redirect_to root_path, flash: { success: "Your event was successfully deleted." }
		else
			redirect_to root_path, flash: { error: "Google was not able to delete your event. Please try again." }
		end
	end

  def update_notes
  	if !@meeting.is_done
	    notes = params[:notes]
	    notes.strip!
	    notes.gsub!(/(<br>|<p>|<div>)/, "\n")
	    notes = strip_tags(notes)
	    notes.strip!
	    notes.gsub!(/(\n+\s*){3,}/, "\n\n")
	    @meeting.update_attributes(notes: notes)
	    render 'update_notes'
  	end
  end

	private

	def meeting_params
		Meeting.format_params(params.require(:meeting).permit(:title, :description, :location, :start_time, :end_time, :time_zone, :notes))
	end

	def find_meeting_by_id
		@meeting = Meeting.find_by_id(params[:id])
	end
end
