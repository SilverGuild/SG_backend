class Dnd5eCacheRefreshJob < ApplicationJob
  queue_as :default

  CATEGORIES = %w[classes subclasses races subraces languages].freeze

  def perform
    CATEGORIES.each do |category|
      Dnd5eDataGateway.refresh(category)
    rescue Dnd5eDataGateway::UnavailableError => e
      Rails.logger.error("Dnd5eCacheRefreshJob: skipping #{category} = #{e.message}")
    end
  end
end
