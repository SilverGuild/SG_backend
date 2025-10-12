class RaceSerializer
  include JSONAPI::Serializer

  set_id do |race|
    race.id
  end

  attribute :name do |race|
    race.name
  end

  attribute :url, if: Proc.new { |record, params|
    params && params[:detailed] == false
  } do |race|
    race.url
  end

  DETAILED_ATTRIBUTES = [
              # :description,
              :speed,
              :size,
              :ability_bonuses,
              :age_description,
              :alignment_description,
              :size_description,
              :language_description,
              :languages
  ]

  DETAILED_ATTRIBUTES.each do |attr|
    attribute attr, if: Proc.new { |record, params|
      params && params[:detailed] == true
    }
  end
end
