class User < ApplicationRecord
  # one-to-many with characters
  has_many :characters, dependent: :destroy

  # Attribute validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
