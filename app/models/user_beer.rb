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

  delegate :name, :tagline, :description, :abv, to: :beer

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
      "id" => beer_id,
      "name" => name,
      "tagline" => tagline, 
      "description" => description, 
      "abv" => abv, 
      "favorite" => favorite?,
      "seen_at" => seen_at,
      "created_at" => created_at,
      "updated_at" => updated_at
    }
  end

  def mark_as_favorite!
    update_attributes favorite: true, seen_at: Time.current
  end

  def mark_as_read!
    update_attributes seen_at: Time.current
  end
  
end
