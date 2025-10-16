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
  validates :character_class_name, presence: true
  validates :subclass_name, presence: true
  validates :race_name, presence: true
  validates :subrace_name, presence: true
end
