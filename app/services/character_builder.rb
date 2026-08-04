class CharacterBuilder
  Result = Struct.new(:success?, :character, keyword_init: true)

  def initialize(user:, character_params:, ability_scores_params: [], skills_params: [], combat_stats_params: {})
    @user = user
    @character_params = character_params
    @ability_scores_params = ability_scores_params
    @skills_params = skills_params
    @combat_stats_params = combat_stats_params
  end

  def call
    character = @user.characters.build(@character_params)

    if dupliacte_ids?(@ability_scores_params, :ability_id)
      character.errors.add(:ability_scores, "contains duplicate ability_id values")
      return Result.new(success?: false, character: character)
    end

    if dupliacte_ids?(@skills_params, :skill_id)
      character.errors.add(:skills, "contains duplicate skill_id values")
      return Result.new(success?: false, character: character)
    end

    @ability_scores_params.each { |params| character.ability_scores.build(params) }
    @skills_params.each { |params| character.skills.build(params) }
    character.build_combat_stats(@combat_stats_params) if @combat_stats_params.present?

    success = false

    ActiveRecord::Base.transaction do
      success = character.save
      raise ActiveRecord::Rollback unless success
    end

    Result.new(success?: success, character: character)
  end

  private

  def dupliacte_ids?(params_array, key)
    ids = params_array.map { |p| p[key] }.compact
    ids.size != ids.uniq.size
  end
end
