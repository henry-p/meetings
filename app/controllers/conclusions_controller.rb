class ConclusionsController < ApplicationController

  def create
    @conclusion = Conclusion.create(content: 'What am I?')
    @agenda_topic = AgendaTopic.find_by_id(params[:agenda_topic_id])
    @agenda_topic.conclusion = @conclusion    
    @meeting = @agenda_topic.meeting
  end

  def update
    @conclusion = Conclusion.find_by_id(params[:id])
    @conclusion.update_attributes(content: params[:content])
  end

end
