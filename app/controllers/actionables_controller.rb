class ActionablesController < ApplicationController
  def index
  end

  def create
    @actionable = Actionable.create(content: "test", creator: current_user, meeting_id: 2)
    @meeting = Meeting.find_by_id(2)
  end

  # def strong_params
  #   params.require(:actionable).permit(:content)
  # end
end
