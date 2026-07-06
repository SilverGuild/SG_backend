class ApplicationController < ActionController::Base
  include ApiErrorHandler
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Cookie-based auth spans two origins (Next :3001 -> Rails :3000), so every
  # browser-originated write request carries an Origin header that will never
  # match request.base_url — Rails' token-based CSRF check would reject all of
  # them regardless of controller. SameSite=Lax on the session cookie is the
  # actual CSRF control for this API, so the token check is skipped globally
  # rather than per-controller. raise: false keeps this safe if the callback
  # isn't in a given controller's chain for any reason.
  skip_before_action :verify_authenticity_token, raise: false

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
