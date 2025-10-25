class LanguageSerializer
  include JSONAPI::Serializer

  set_id do |lang|
    lang.id
  end

  attribute :name do |lang|
    lang.name
  end

  attribute :url, if: Proc.new { |record, params|
    params && params[:detailed] == false
  } do |lang|
    lang.url
  end

  DETAILED_ATTRIBUTES = [
    :language_type,
    :typical_speakers,
    :script
  ]

  DETAILED_ATTRIBUTES.each do |attr|
    attribute attr, if: Proc.new { |record, params|
      params && params[:detailed] == true
    }
  end
end
