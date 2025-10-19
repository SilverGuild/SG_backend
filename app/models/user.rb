class User < ApplicationRecord
  # one-to-many with characters
  has_many :characters, dependent: :destroy

  # Attribute validations
  validates :username, presence: true
  validates :email, presence: true
end
