class CharacterSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :name,
              :level,
              :experience_points,
              :alignment,
              :background,
              :user_id,
              :character_class_id,
              :race_id,
              :subclass_id,
              :subrace_id,
              :languages

  attribute :ability_scores do |character|
    character.ability_scores.map do |a|
      {
        ability_id: a.ability_id,
        score: a.score,
        saving_throw_proficient: a.saving_throw_proficient,
      }
    end
  end
  
  attribute :skills do |character|
    character.skills.map do |s|
      {
        skill_id: s.skill_id,
        proficient: s.proficient,
        expertise: s.expertise
      }
    end
  end

  attribute :combat_stats do |character|
    cs = character.combat_stats
    next nil unless cs

    {
      current_hp: cs.current_hp,
      max_hp: cs.max_hp,
      temporary_hp: cs.temporary_hp,
      hit_dice_remaining: cs.hit_dice_remaining,
      death_save_successes: cs.death_save_successes,
      death_save_failures: cs.death_save_failures,
      stable: cs.stable,
      armor_class: cs.armor_class,
      conditions: cs.conditions,
    }
  end
end
