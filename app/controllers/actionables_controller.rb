class ActionablesController < ApplicationController
  def index
  end

  def create
    @actionable = Actionable.create(content: params[:actionable][:content], creator: current_user, meeting_id: params[:meeting_id])
    @meeting = @actionable.meeting
  end

  def update
    @actionable = Actionable.find_by_id(params[:id]) 
    @actionable.update_attributes(content: params[:content])
    @meeting = @actionable.meeting
  end

  def destroy
    @actionable = Actionable.find_by_id(params[:id])
    @meeting = @actionable.meeting
    @actionable.destroy
  end
end