class CharacterClassPoro
  include PoroTransformations

  attr_reader :id,
              :name,
              :url,
              # :description,
              :hit_die,
              :skill_proficiencies,
              :saving_throw_proficiencies

  def initialize(class_data)
    @id                         = class_data[:index]&.downcase
    # require "pry"; binding.pry
    @name                       = class_data[:name]
    @url                        = class_data[:url]
    # @description                = class_data[:description]
    @hit_die                    = class_data[:hit_die]
    @skill_proficiencies        = class_data[:proficiency_choices] == nil ? class_data[:proficiency_choices] : { choose: class_data[:proficiency_choices].first[:choose], skills: list_skill_proficiencies(class_data[:proficiency_choices].first[:from][:options]) }
    @saving_throw_proficiencies = class_data[:saving_throws] == nil ? class_data[:saving_throws] : list_proficiencies(class_data[:saving_throws])
  end

  private

  def list_skill_proficiencies(skills)
    skills.map { |skill|  skill[:item][:index].split("-").last }
  end

  def list_proficiencies(proficiencies)
    proficiencies.map { |prof| prof[:index] }
  end
end
