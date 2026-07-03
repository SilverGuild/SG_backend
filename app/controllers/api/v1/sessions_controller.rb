class Api::V1::SessionsController < ApplicationController
  # Cookie based login.  The SameSite=Lax session cookie is the CSRF control for
  # these JSON endpoints, so token-based forgery protection is skipped here.
  # raise: false makes this safe whether or not the callbakc is in the chain
  skip_before_action :verify_authenticity_token, raise: false

  def create
    user = User.find_by(username: session_params[:username])

    if user&.authenticate(session_params[:password])
      reset_session
      session[:user_id] = user.id

      cookies[:sg_logged_in] = {
        value: "1",
        same_site: :lax,
        secure: Rails.env.production?,
        expires: 14.days.from_now
      }

      render json: UserSerializer.new(user).serializable_hash, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    cookies.delete(:sg_logged_in)
    head :no_content
  end

  def current
    if current_user
      render json: UserSerializer.new(current_user).serializable_hash
    else
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
