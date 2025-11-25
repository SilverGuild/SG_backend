class Api::V1::UsersController < ApplicationController
  before_action :validate_id_format, only: [ :show, :update, :destroy ]
  before_action :set_user, only: [ :show, :update, :destroy ]

  def index
    users = User.all

    render json: UserSerializer.new(users).serializable_hash
  end

  def show
    render json: UserSerializer.new(@user).serializable_hash
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: "Account created successfully", data: @user }, status: :created
    else
      render_param_errors
    end
  end

  def update
    if params[:user]&.key?(:username) && params[:user][:username] == ""
      return render json: { error: "Username is empty" }, status: :bad_request
    end

    if params[:user]&.key?(:email) && params[:user][:email] == ""
      return render json: { error: "Email is empty" }, status: :bad_request
    end

    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash
    else
      render_param_errors
    end
  end

  def destroy
    @user.destroy

    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:id].to_s.match?(/^\d+$/) && params[:id].to_i > 0
      render json: { error: "Invalid user ID" }, status: :bad_request
    end
  end

  def render_param_errors
    if @user.errors[:username].include?("has already been taken") && @user.errors[:email].include?("has already been taken")
      render json: { error: "User already exists" }, status: :unprocessable_content
    elsif @user.errors[:username].include?("has already been taken")
      render json: { error: "User already exists with this username" }, status: :unprocessable_content
    elsif @user.errors[:email].include?("has already been taken")
      render json: { error: "User already exists with this email" }, status: :unprocessable_content
    elsif @user.errors[:username].include?("can't be blank")
      render json: { error: "Username is required" }, status: :bad_request
    elsif @user.errors[:email].include?("can't be blank")
      render json: { error: "Email is required" }, status: :bad_request
    elsif @user.errors[:email].include?("is invalid")
      render json: { error: "Email is invalid" }, status: :bad_request
    else
      render json: { error: @user.errors.full_messages.join(", ") }, status: :bad_request
    end
  end

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
