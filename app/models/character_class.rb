class CharacterClass < ApplicationRecord
  # Many-to-many with characters
  has_many :characters_char_classes
  has_many :characters, through: :characters_char_classes

  # Attribute validations
  validates :name, presence: true
  validates :description, presence: true
  validates :hit_die, presence: true
  validates :skill_proficiencies, presence: true
  validates :saving_throw_proficiencies, presence: true
end
