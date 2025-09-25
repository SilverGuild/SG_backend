class RacePoro
  include PoroTransformations

  attr_reader :name, 
              :description, 
              :speed, 
              :size,
              :ability_bonuses,
              :age_description,
              :alignment_description,
              :size_description,
              :languages_description,
              :languages
  
  def initialize(race_data)
    @name                   = race_data[:name]    
    @description            = race_data[:description]
    @speed                  = race_data[:speed]
    @size                   = race_data[:size]
    @ability_bonuses        = json_to_array(race_data[:ability_bonuses])
    @age_description        = race_data[:age_description]
    @alignment_description  = race_data[:alignment_description] 
    @size_description       = race_data[:size_description]
    @languages_description  = race_data[:languages_description]
    @languages              = json_to_array(race_data[:languages])
  end
end