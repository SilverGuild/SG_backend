class Character < ApplicationRecord
  # Association validation
  belongs_to :user
  validates :user_id, presence: true

  # Presence validations
  validates :name, presence: true
  validates :level, presence: true
  validates :experience_points, presence: true
  validates :alignment, presence: true
  validates :background, presence: true
  validates :character_class_id, presence: true
  validates :race_id, presence: true
  validates :languages, length: { minimum: 1, message: "can't be blank" }

  # Type validations
  validates :level, numericality: { only_integer: true, greater_than: 0 }
  validates :experience_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Format validations
  validates :character_class_id, format: { with: /\A[a-z-]+\z/, message: "is invalid" }
  validates :race_id, format: { with: /\A[a-z-]+\z/, message: "is invalid" }
  validates :subclass_id, format: { with: /\A[a-z-]+\z/, message: "is invalid" }, allow_blank: true
  validates :subrace_id, format: { with: /\A[a-z-]+\z/, message: "is invalid" }, allow_blank: true

  # Uniqueness validations
  validates :name, uniqueness: { scope: :user_id, message: "has already been taken" }

  # Custom validations
  validate :validate_languages_format

  # Helper methods: Attribute management
  def add_language(*langs)
    self.languages ||= []

    self.languages = (self.languages + langs.flatten.compact).uniq.sort

    save
  end

  # Retrieve details on character attributes
  def character_class
    @character_class ||= begin
      data = Dnd5eDataGateway.fetch_character_classes(character_class_id)
      CharacterClassPoro.new(data)
    end
  end

  def subclass
    @subclass ||= begin
      data = Dnd5eDataGateway.fetch_subclasses(subclass_id)
      SubclassPoro.new(data)
    end
  end

  def race
    @race ||= begin
      data = Dnd5eDataGateway.fetch_races(race_id)
      RacePoro.new(data)
    end
  end

  def subrace
    @subrace ||= begin
      data = Dnd5eDataGateway.fetch_subraces(subrace_id)
      SubracePoro.new(data)
    end
  end

  def language(lang)
    @language ||= begin
      data = Dnd5eDataGateway.fetch_langauges(lang)
      LanguagePoro.new(data)
    end
  end

  private

  def validate_languages_format
    unless languages.is_a?(Array)
      errors.add(:languages, "is invalid")
      return
    end

    unless languages.all? { |lang| lang.is_a?(String) }
      errors.add(:languages, "is invalid")
    end
  end
end
