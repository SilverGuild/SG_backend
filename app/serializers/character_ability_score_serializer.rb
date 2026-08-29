class CharacterAbilityScoreSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :ability_id,
              :character_id,
              :saving_throw_proficient,
              :score
end
