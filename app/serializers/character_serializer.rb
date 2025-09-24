class CharacterSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :name,
              :level,
              :experience_points,
              :alignment,
              :background,
              :user_id
end
