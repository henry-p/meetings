class AgendaTopicsController < ApplicationController
  def new
    @meeting = Meeting.find_by_id(params[:meeting_id])
    @agenda = AgendaTopic.new(meeting: @meeting)

    respond_to do |format|
      format.html
      format.js 
    end    
  end



  def create
    @meeting = Meeting.find_by_id(params[:meeting_id])

    @agenda = AgendaTopic.new(meeting: @meeting, content: params[:content][0], creator: current_user)
    @agenda.save

    respond_to do |format|
      format.html { redirect_to meeting_path(@meeting) }
      format.js
    end  
  end
end
