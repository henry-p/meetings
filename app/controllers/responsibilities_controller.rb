class ResponsibilitiesController < ApplicationController
  before_filter :find_goodies

  def create
    if !@meeting.is_done
      @user = User.find_by_id(params[:user_id])
      @responsibility = Responsibility.new(user_id: params[:user_id], actionable_id: @actionable.id)
      unless @responsibility.save
        redirect_to meeting_path(@meeting)
      end
    else
      redirect_to meeting_path(@meeting)
    end
  end

  def destroy
    @responsibility = Responsibility.find_by_id(params[:id])
    @user = User.find_by_id(@responsibility.user_id)
    @responsibility.destroy
  end

  private

  def find_goodies
    @actionable = Actionable.find_by_id(params[:actionable_id])
    @meeting = @actionable.meeting
  end
end