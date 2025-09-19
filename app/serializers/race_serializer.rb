class RaceSerializer
  include JSONAPI::Serializer
  include SerializationHelpers

  attributes  :name,
              :description,
              :speed,
              :size,
              :ability_bonuses,
              :age_description,
              :alignment_description,
              :size_description,
              :languages_description,
              :languages
end
