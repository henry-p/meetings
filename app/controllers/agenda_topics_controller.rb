class AgendaTopicsController < ApplicationController
  before_filter { |filter| filter.check_if_meeting_is_closed(params[:meeting_id]) }

  def new
    @agenda = AgendaTopic.new(meeting: @meeting)

    respond_to do |format|
      format.html
      format.js 
    end    
  end

  def create
    @agenda = AgendaTopic.new(meeting: @meeting, content: params[:content][0], creator: current_user)
    @agenda.save

    respond_to do |format|
      format.html { redirect_to meeting_path(@meeting) }
      format.js
    end  
  end

  def destroy
    @agenda_topic = AgendaTopic.find_by_id(params[:id])
    @agenda_topic.destroy

    respond_to do |format|
      format.html { redirect_to meeting_path(@meeting) }
      format.js
    end      
  end

  def update
    @agenda_topic = AgendaTopic.find_by_id(params[:id])

    @agenda_topic.update(content: params[:content])

    respond_to do |format|
      # format.html { redirect_to meeting_path(@meeting) }
      format.js
    end       
  end
end



