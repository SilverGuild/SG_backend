class CharacterCombatStats < ApplicationRecord
  belongs_to(:character)

  validates :character_id, uniqueness: true

  validates :current_hp, presence: true
  validates :current_hp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :max_hp, presence: true
  validates :max_hp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :temporary_hp, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :hit_dice_remaining, presence: true
  validates :hit_dice_remaining, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :death_save_successes, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }
  validates :death_save_failures, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3 }

  validates :stable, inclusion: { in: [ true, false ] }

  validates :armor_class, presence: true
  validates :armor_class, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :current_hp_within_max
  validate :hit_dice_remaining_within_level
  validate :validate_conditions_format

  private

  def current_hp_within_max
    return if current_hp.nil? || max_hp.nil?

    errors.add(:current_hp, "can't exceed max hp") if current_hp > max_hp
  end

  def hit_dice_remaining_within_level
   return if hit_dice_remaining.nil? || character.nil?

   errors.add(:hit_dice_remaining, "can't exceed character level") if hit_dice_remaining > character.level
  end

  def validate_conditions_format
    unless conditions.is_a?(Array)
      errors.add(:conditions, "is invalid")
      return
    end

    unless conditions.all? { |c| c.is_a?(String) && c.match?(/\A[a-z-]+\z/) }
      errors.add(:conditions, "contains an invalid condition slug")
    end
  end
end