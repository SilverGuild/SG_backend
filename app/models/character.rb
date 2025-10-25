class Character < ApplicationRecord
  # One-to-many with users
  belongs_to :user

  # Attribute validations
  validates :name, presence: true
  validates :level, presence: true
  validates :experience_points, presence: true
  validates :alignment, presence: true
  validates :background, presence: true
  validates :user_id, presence: true
  validates :character_class_id, presence: true
  validates :race_id, presence: true

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
end
