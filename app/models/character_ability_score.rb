class CharacterAbilityScore < ApplicationRecord
  belongs_to :character

  validates :ability_id, presence: true
  validates :ability_id, format: { with: /\A[a-z-]+\z/, message: "is invalid" }, allow_blank: true
  validates :ability_id, uniqueness: { scope: :character_id }

  validates :score, presence: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 30 }

  validates :saving_throw_proficient, inclusion: { in: [ true, false ] }
end
