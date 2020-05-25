class User < ApplicationRecord
  has_secure_password

  # ASSOCIATIONS
  # -----------------------------

  has_many :user_beers
  has_many :beers, through: :user_beers

  # METHODS
  # -----------------------------

  def to_token
    {
        id: self.id,
        name: self.name,
        username: self.username,
    }
  end
end
