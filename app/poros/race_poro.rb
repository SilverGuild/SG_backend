class RacePoro
  include PoroTransformations

  attr_reader :id,
              :name,
              :url,
              # :description,
              :speed,
              :size,
              :ability_bonuses,
              :age_description,
              :alignment_description,
              :size_description,
              :language_description,
              :languages

  def initialize(race_data)
    # require "pry"; binding.pry
    @id                     = race_data[:index]&.downcase
    @name                   = race_data[:name]
    @url                    = race_data[:url]
    # @description            = race_data[:description]
    @speed                  = race_data[:speed]
    @size                   = race_data[:size]
    @ability_bonuses        = race_data[:ability_bonuses] == nil ? race_data[:ability_bonuses] : json_to_array(race_data[:ability_bonuses])
    @age_description        = race_data[:age]
    @alignment_description  = race_data[:alignment]
    @size_description       = race_data[:size_description]
    @language_description   = race_data[:language_desc]
    @languages              = json_to_array(race_data[:languages])
  end
end
