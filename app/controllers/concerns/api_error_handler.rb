module ApiErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Faraday::ConnectionFailed, Faraday::TimeoutError do |e|
      render json: { error: "Unable to reach external dnd5e API" }, status: :internal_server_error
    end
  end
end
