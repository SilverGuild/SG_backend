class SubclassSerializer
  include JSONAPI::Serializer

  set_id do |subclass|
    subclass.id
  end

  attribute :name do |subclass|
    subclass.name
  end

  attribute :url, if: Proc.new { |record, params|
    params && params[:detailed] == false
  } do |subclass|
    subclass.url
  end

  DETAILED_ATTRIBUTES = [
    :class_id,
    :description,
    :flavor
  ]

  DETAILED_ATTRIBUTES.each do |attr|
    attribute attr, if: Proc.new { |record, params|
      params && params[:detailed] == true
    }
  end
end
