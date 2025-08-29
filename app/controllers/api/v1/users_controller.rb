class Api::V1::UsersController < ApplicationController

  def index
    users = User.all

    render json: UserSerializer.new(users).serializable_hash
  end

  private

  def allow_params
    params.permit(:id, :username, :email)
  end
end
