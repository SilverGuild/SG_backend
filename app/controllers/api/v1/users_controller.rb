class Api::V1::UsersController < ApplicationController

  def index
    users = User.all

    render json: UserSerializer.new(users).serializable_hash
  end

  def show
    user = User.find_by(id: params[:id])\
   
    render json: UserSerializer.new(user).serializable_hash
  end

  def create
    user = User.create!(user_params)

    render json: { message: 'Account created successfully', data: user}, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
