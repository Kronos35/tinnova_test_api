class UserBeer < ApplicationRecord

  # ASSOCIATIONS
  # --------------------

  belongs_to :user
  belongs_to :beer

  # VALIDATIONS
  # --------------------

  validates :user, uniqueness: { scope: :beer }
  validates :beer, uniqueness: { scope: :user }

  # DELEGATIONS
  # --------------------

  delegate :name, :tagline, :description, :abv, :seen_at, to: :beer

  # SCOPES
  # --------------------

  scope :search, -> (query) do
    return all if query.blank? || query.nil?
    joins(:beer).where('beers.name LIKE ? OR beers.abv = ?',"%#{query}%", query.to_f)
  end

  # METHODS
  # --------------------

  def as_json(*args)
    {
      "id" => self.beer_id,
      "name" => self.name,
      "tagline" => self.tagline, 
      "description" => self.description, 
      "abv" => self.abv, 
      "favorite" => self.favorite?,
      "seen_at" => self.seen_at,
      "created_at" => self.created_at,
      "updated_at" => self.updated_at
    }
  end
  
end
