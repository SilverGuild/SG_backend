class LanguagePoro
  attr_reader :id,
              :name,
              :language_type,
              :typical_speakers,
              :script

  def initialize(language_data)
    @id               = language_data[:index]
    @name             = language_data[:name]
    @language_type    = language_data[:type]
    @typical_speakers = language_data[:typical_speakers]
    @script           = language_data[:script]
  end
end
