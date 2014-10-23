class UsersController < ApplicationController
  def show
    @meetings = current_user.all_meetings_chronologically
  end

  def archive
    @meetings = current_user.all_finished_meetings.reverse
  end

  def contacts
    contacts = current_user.load_contacts_from_redis
    respond_to do |format|
      format.json { render json: contacts }
    end
  end

  def init_contacts_load
    if current_user.token && !$redis.exists(current_user.google_contacts_key) 
      if current_user.contacts_jid.nil?
        current_user.touch
        job_id = GoogleWorker.perform_async(current_user.id)
        current_user.update_attribute(:contacts_jid, job_id)
        
        render json: { jid: job_id } and return
      else
        render json: { jid: current_user.contacts_jid } and return
      end
    else
      render json: { jid: false } and return
    end
  end

  def check_on_contacts_loading
    if job_is_complete(params[:jid])
      render json: { done: true }
    else
      render json: { done: false }
    end
  end
end