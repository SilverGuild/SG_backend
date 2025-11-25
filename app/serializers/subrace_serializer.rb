class SubraceSerializer
  include JSONAPI::Serializer

  set_id do |subrace|
    subrace.id
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
    :race_id,
    :description,
    :ability_bonuses
  ]

  DETAILED_ATTRIBUTES.each do |attr|
    attribute attr, if: Proc.new { |record, params|
      params && params[:detailed] == true
    }
  end
end
