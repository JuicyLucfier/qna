class BadgesController < ApplicationController
  before_action :authenticate_user!

  expose :badge

  def index
    @user_badges = current_user.badges
  end

  private

  def badge_params
    params.require(:badge).permit(:title, :image)
  end
end
