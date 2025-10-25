class SubracePoro
  include PoroTransformations

  attr_reader :id,
              :name,
              :race_id,
              :description,
              :ability_bonuses,
              :url

  def initialize(subrace_data)
    @id               = subrace_data[:index]
    @name             = subrace_data[:name]
    @race_id          = subrace_data[:race][:index]
    @description      = subrace_data[:desc]
    @ability_bonuses  = subrace_data[:ability_bonuses] == nil ? subrace_data[:ability_bonuses] : json_to_array(subrace_data[:ability_bonuses])
    @url              = subrace_data[:url]
  end
end
