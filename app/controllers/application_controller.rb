class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login

  helper_method :current_user, :logged_in?

  def logged_in?
    current_user ? true : false
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
 
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to view this page"
      redirect_to root_path
    end
  end

  def check_if_meeting_is_closed(id)
    @meeting = Meeting.find_by_id(id)

    if @meeting.is_done
      redirect_to meeting_path(@meeting)
    end
  end

  def google_api_call_success?(response)
    return true if response.status.to_s =~ /20/
    false
  end

  def google_api_call_404(response)
    return true if response.status.to_s =~ /40/
    false
  end  

  def job_is_complete(jid)
    waiting = Sidekiq::Queue.new
    working = Sidekiq::Workers.new
    pending = Sidekiq::ScheduledSet.new
    return false if pending.find { |job| job.jid == jid }
    return false if waiting.find { |job| job.jid == jid }
    return false if working.find { |worker, info| info["payload"]["jid"] == jid }
    true
  end  
end
