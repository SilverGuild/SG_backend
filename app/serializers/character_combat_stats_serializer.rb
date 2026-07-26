class CharacterCombatStatsSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :character_id,
              :current_hp,
              :temporary_hp,
              :max_hp,
              :hit_dice_remaining,
              :death_save_successes,
              :death_save_failures,
              :conditions,
              :stable
end
