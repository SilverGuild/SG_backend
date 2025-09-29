class CharacterClassPoro
  include PoroTransformations

  attr_reader :name,
              :description,
              :hit_die,
              :skill_proficiencies,
              :saving_throw_proficiencies

  def initialize(class_data)
    @name                       = class_data[:name]
    @description                = class_data[:description]
    @hit_die                    = class_data[:hit_die]
    @skill_proficiencies        = json_to_array(class_data[:skill_proficiencies])
    @saving_throw_proficiencies = class_data[:saving_throw_proficiencies]
  end
end
