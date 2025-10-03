class Dnd5eDataGateway
  def self.fetch_dnd_data(category, id = "")
    conn = connect()
  
    response = conn.get("api/2014/#{category}")
  
    json = JSON.parse(response.body, symbolize_names: true)
    results = json[:results]
    
    results
  end
  
  private
  
  def self.connect
    Faraday.new(url: "https://www.dnd5eapi.co/")
  end
end
