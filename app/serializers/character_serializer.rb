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
              :subrace_id
end
