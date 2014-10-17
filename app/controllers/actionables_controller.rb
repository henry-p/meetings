class ActionablesController < ApplicationController
  def index
  end

  def create
    @actionable = Actionable.create(content: params[:actionable][:content], creator: current_user, meeting_id: params[:meeting_id])
    @meeting = Meeting.find_by_id(params[:meeting_id])
  end

  # def strong_params
  #   params.require(:actionable).permit(:content, :creator, :meeting_id)
  # end
end
