module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Faraday::ConnectionFailed, Faraday::TimeoutError do |e|
      render json: { error: "Unable to reach external dnd5e API" }, status: :internal_server_error
    end

    rescue_from ActiveRecord::RecordNotFound do |_e|
      render_error("Resource not found", :not_found)
    end

    rescue_from ActionController::ParameterMissing do |_e|
      render_error("Required parameter missing", :bad_request)
    end
  end

  private

  # Generic envelope - every controller renders errors the same way
  def render_error(message, status)
    render json: { error: message}, status: status
  end
end
