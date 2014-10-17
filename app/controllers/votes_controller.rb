class VotesController < ApplicationController
  def create
    vote = Vote.new(agenda_topic_id: params[:agenda_topic_id], voter: current_user)

    if Vote.find_by(agenda_topic_id: params[:agenda_topic_id], voter: current_user)
      nil
    else
      vote.save
    end

    respond_to do |format|
      format.html { redirect_to meeting_path(params[:meeting_id]) }
    end  
  end
end
