class CharacterSkill < ApplicationRecord
  belongs_to :character

  validates :skill_id, presence: true
  validates :skill_id, format: { with: /\A[a-z-]+\z/, message: "is invalid" }, allow_blank: true
  validates :skill_id, uniqueness: { scope: :character_id }

  validate :expertise_requires_proficiency

  private

  def expertise_requires_proficiency
    if expertise? && !proficient?
      errors.add(:expertise, "can't be true without proficiency in the skill first")
    end
  end
end
