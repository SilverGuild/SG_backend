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

    merge_nested_errors(character) unless success

    Result.new(success?: success, character: character)
  end

  private

  def dupliacte_ids?(params_array, key)
    ids = params_array.map { |p| p[key] }.compact
    ids.size != ids.uniq.size
  end

  # has_one/has_many with validate: true (and no autosave) only add a
  # generic "<association> is invalid" error on the parent — it doesn't
  # import the child record's actual attribute-level messages. This
  # replaces that generic error with the real ones, so
  # render_param_errors has something specific to surface.
  def merge_nested_errors(character)
    merge_association_errors(character, character.ability_scores, :ability_scores, indexed: true)
    merge_association_errors(character, character.skills, :skills, indexed: true)
    merge_association_errors(character, Array(character.combat_stats), :combat_stats, indexed: false)
  end

  def merge_association_errors(character, records, association_name, indexed:)
    return if records.empty?

    character.errors.delete(association_name)

    records.each_with_index do |record, index|
      next if record.valid?

      record.errors.each do |error|
        key = indexed ? :"#{association_name}[#{index}].#{error.attribute}" : :"#{association_name}.#{error.attribute}"
        character.errors.add(key, error.message)
      end
    end
  end
end
