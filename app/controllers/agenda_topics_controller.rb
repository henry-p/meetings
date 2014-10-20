class AgendaTopicsController < ApplicationController
  before_filter { |filter| filter.check_if_meeting_is_closed(params[:meeting_id]) }

  def create
    @agenda_topic = AgendaTopic.new(meeting_id: @meeting.id, content: params[:agenda_topic][:content], creator: current_user)
    @agenda_topic.save

    respond_to do |format|
      format.html { redirect_to meeting_path(@meeting) }
      format.js
    end  
  end

  def destroy
    @agenda_topic = AgendaTopic.find_by_id(params[:id])
    @agenda_topic.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to meeting_path(@meeting) }
    end      
  end

  def update
    p @meeting
    @agenda_topic = AgendaTopic.find_by_id(params[:id])
    @agenda_topic.update(content: params[:content])

    respond_to do |format|
      format.js
      format.html { redirect_to meeting_path(@meeting) }
    end       
  end
end



