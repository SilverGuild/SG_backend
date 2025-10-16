class CharacterClassSerializer
  include JSONAPI::Serializer

  set_id do |char_class|
    char_class.id
  end

  attribute :name do |char_class|
    char_class.name
  end

  attribute :url, if: Proc.new { |record, params|
    params && params[:detailed] == false
  } do |char_class|
    char_class.url
  end

  DETAILED_ATTRIBUTES = [
    # :description,
    :hit_die,
    :skill_proficiencies,
    :saving_throw_proficiencies
  ]

  DETAILED_ATTRIBUTES.each do |attr|
    attribute attr, if: Proc.new { |record, params|
      params && params[:detailed] == true
    }
  end
end
