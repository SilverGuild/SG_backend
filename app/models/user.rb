class User < ApplicationRecord
  # one-to-many with characters
  has_many :characters

  # Attribute validations
  validates :name, presence: true
  validates :email, presence: true
end
