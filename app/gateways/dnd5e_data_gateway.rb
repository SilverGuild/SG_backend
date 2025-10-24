class Dnd5eDataGateway
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

  def self.fetch_langauges(id = "")
    fetch_dnd_data("languages", id)
  end

  def self.fetch_dnd_data(category, id = "")
    conn = connect()
    endpoint = id.empty? ? "api/2014/#{category}" : "api/2014/#{category}/#{id}"
    response = conn.get(endpoint)
    json = JSON.parse(response.body, symbolize_names: true)
    results = id.empty? ? json[:results] : json
    results
  end

  private

  def self.connect
    Faraday.new(url: "https://www.dnd5eapi.co/")
  end
end
