class CharacterDataGateway
  def self.fetch_classes
    conn = connect()
    response = conn.get("api/2014/classes/")

    json = JSON.parse(response.body, symbolize_names: true)
    classes = json[:results]

    classes
  end

  def self.fetch_races
    conn = connect()
    response = conn.get("api/2014/races/")

    json = JSON.parse(response.body, symbolize_names: true)
    races = json[:results]

    races
  end

  def self.fetch_languages
    conn = connect()
    response = conn.get("api/2014/languages/")

    json = JSON.parse(response.body, symbolize_names: true)
    languages = json[:results]

    languages
  end

  private

  def self.connect
    Faraday.new(url: "https://www.dnd5eapi.co/")
  end
end
