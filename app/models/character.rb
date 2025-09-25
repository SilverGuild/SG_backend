class Character < ApplicationRecord
  # Many-to-many with races
  has_many :characters_races
  has_many :races, through: :characters_races
  # Many-to-many with classes
  has_many :character_char_classes
  has_many :classes, through: :characters_char_classes
  # One-to-many with users
  belongs_to :user

  # Attribute validations
  validates :name, presence: true
  validates :level, presence: true
  validates :experience_points, presence: true
  validates :alignment, presence: true
  validates :background, presence: true
  validates :user_id, presence: true
end
