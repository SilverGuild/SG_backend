class Dnd5eDataGateway
  class UnavailableError < StandardError; end

  CACHE_EXPIRY = 1.week

  def self.fetch_character_classes(id = "")
    fetch_dnd_data("classes", id)
  end

  def self.fetch_subclasses(id = "")
    fetch_dnd_data("subclasses", id)
  end

  def self.fetch_races(id = "")
    fetch_dnd_data("races", id)
  end

  def self.fetch_subraces(id = "")
    fetch_dnd_data("subraces", id)
  end

  def self.fetch_languages(id = "")
    fetch_dnd_data("languages", id)
  end

  def self.fetch_dnd_data(category, id = "")
    Rails.cache.fetch(cache_key(category, id), expires_in: CACHE_EXPIRY) do 
      fetch_from_api(category, id)
    end
  end
  
  # Bypass the cache and write a fresh value into the cache.
  # Used by a schedueld refresh job - errors NOT rescued here,
  # failed refresh leaves the previous cache value in place rather
  # than overwriting with nothing
  def self.refresh(category, id = "")
    Rails.cache.write(cache_key(category, id), fetch_from_api(category, id), expires_in: CACHE_EXPIRY)
  end

  def self.cache_key(category, id)
    id.empty? ? "dnd5e/#{category}" : "dnd5e/#{category}/#{id}"
  end
  
  def self.fetch_from_api(category, id = "")
    endpoint = id.empty? ? "api/2014/#{category}" : "api/2014/#{category}/#{id}"
    response = connect.get(endpoint)

    case response.status
    when 200
      json = JSON.parse(response.body, symbolize_names: true)
      id.empty? ? json[:results] : json
    when 404
      nil
    else
      raise UnavailableError, "Unexpected API response: #{ response.status }"
    end
  rescue Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::SSLError => e
    raise UnavailableError, "5e API unreachable: #{e.class}"
  end

  def self.connect
    Faraday.new(url: "https://www.dnd5eapi.co/")
  end
  private_class_method :connect
end
