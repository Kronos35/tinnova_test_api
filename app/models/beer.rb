class Beer < ApplicationRecord
  # ASSOCIATIONS
  # -------------------------

  has_many :user_beers
  has_many :users, through: :user_beers

  # VALIDATIONS
  # -------------------------

  validates :abv, presence: true
  validates :name, presence: true
  validates :tagline, presence: true
  validates :description, presence: true

end
