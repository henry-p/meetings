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

  def init_contacts_load
    if current_user.token && !$redis.exists(current_user.id.to_s) && (current_user.contacts_jid.nil? || current_user.contacts_jid.empty?)
      job_id = GoogleWorker.perform_async(current_user.id)
      current_user.update(contacts_jid: job_id)
      render json: { jid: job_id }
    elsif current_user.token && !$redis.exists(current_user.id.to_s) && current_user.contacts_jid
      render json: { jid: current_user.contacts_jid }
    else
      render json: { jid: false }
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