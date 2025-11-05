class Api::V1::UsersController < ApplicationController
  def index
    users = User.all

    render json: UserSerializer.new(users).serializable_hash
  end

  def show
    user = User.find(params[:id])

    render json: UserSerializer.new(user).serializable_hash
  end

  def create
    user = User.create!(user_params)

    render json: { message: "Account created successfully", data: user }, status: :created
  end

  def update
    user = User.find(params[:id])

    user.update(user_params)

    render json: UserSerializer.new(user).serializable_hash
  end

  def destroy
    user = User.find(params[:id])

    user.destroy

    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
