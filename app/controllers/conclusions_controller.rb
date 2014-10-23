class ConclusionsController < ApplicationController
  before_filter { |filter| filter.check_if_meeting_is_closed(params[:meeting_id]) }

  def create
    @conclusion = Conclusion.create(content: '')
    @agenda_topic = AgendaTopic.find_by_id(params[:agenda_topic_id])
    @agenda_topic.conclusion = @conclusion    
    @meeting = @agenda_topic.meeting
  end

  def update
    @conclusion = Conclusion.find_by_id(params[:id])
    @conclusion_id = @conclusion.id
    @agenda_topic = @conclusion.agenda_topic
    @meeting = @agenda_topic.meeting
    if params[:content] == ''
      @conclusion.destroy
      render "update_blank"
    else
      @conclusion.update_attributes(content: params[:content])
    end
  end

end
