class ApplicationController < ActionController::Base
  include ApiErrorHandler
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # Reads the user id from the encrypted session cookie
  # find_by (not find) so a stale/delete id returns nil instead of raising
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # before_action you can opt-in on protected endpoints later
  def require_authentication
    render json: { error: "Not authenticated" }, status: :unauthorized
  end
end
