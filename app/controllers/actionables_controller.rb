class ActionablesController < ApplicationController
  before_filter { |filter| filter.check_if_meeting_is_closed(params[:meeting_id]) }

  def create
    @actionable = Actionable.create(content: params[:actionable][:content], creator: current_user, meeting_id: params[:meeting_id])
  end

  def update
    @actionable = Actionable.find_by_id(params[:id]) 
    @actionable.update_attributes(content: params[:content])
  end

  def destroy
    @actionable = Actionable.find_by_id(params[:id])
  end
end