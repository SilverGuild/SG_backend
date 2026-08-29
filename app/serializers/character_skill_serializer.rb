class CharacterSkillSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :skill_id,
              :character_id,
              :proficient,
              :expertise
end
