class CharacterClassSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :name,
              :description,
              :hit_die,
              :skill_proficiencies,
              :saving_throw_proficiencies
end