class ResponsibilitiesController < ApplicationController

  def create
    @actionable = Actionable.find_by_id(params[:actionable_id])
    @meeting = @actionable.meeting
    @user = User.find_by_id(params[:user_id])
    @responsibility = Responsibility.create(user_id: params[:user_id], actionable_id: params[:actionable_id])
  end

end