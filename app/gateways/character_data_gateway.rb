class CharacterDataGateway
  def self.fetch_classes
    conn = connect()
    response = conn.get("api/2014/classes/")

    json = JSON.parse(response.body, symbolize_names: true)
    classes = json[:results]

    return classes
  end

  def self.fetch_races

  end

  def self.fetch_languages

  end

  private
  
  def self.connect
    Faraday.new(url: "https://www.dnd5eapi.co/")
  end
end