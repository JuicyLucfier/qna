class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    @users = User.all_except(current_resource_owner)
    render json: @users
  end

  def me
    render json: current_resource_owner
  end
end
