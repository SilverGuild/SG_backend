class Race < ApplicationRecord
  # Many-to-many with characters
  has_many :characters_races
  has_many :races, through: :characters_races

  # One-to-many with subraces

  # Validate attributes
  validates :name, presence: true
  validates :description, presence: true
  validates :speed, presence: true
  validates :size, presence: true
  validates :ability_bonuses, presence: true
  validates :age_description, presence: true
  validates :alignment_description, presence: true
  validates :size_description, presence: true
  validates :languages_description, presence: true
  validates :languages, presence: true
end
