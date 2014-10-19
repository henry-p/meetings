class VotesController < ApplicationController

  def create
    @vote = Vote.new(agenda_topic_id: params[:agenda_topic_id], voter: current_user)

    if Vote.find_by(agenda_topic_id: params[:agenda_topic_id], voter: current_user)
      respond_to do |format|
        format.html { redirect_to meeting_path(params[:meeting_id]) }
      end  
    else
      @vote.save

      respond_to do |format|
        format.html { redirect_to meeting_path(params[:meeting_id]) }
        format.js
      end  
    end
  end

end
