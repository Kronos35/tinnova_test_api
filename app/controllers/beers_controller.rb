class BeersController < ApplicationController
  before_action :authenticate!
  before_action :update_beers!, only: [:index]
  before_action :update_beer!, only: [:show, :set_favorite]

  def index
    @beers = @current_user.user_beers.search params[:query]
    render json: { beers: @beers }
  end

  def show
    render json: { beer: @beer }
  end

  def set_favorite
    render json: { beer: @beer }
  end

  private

  def update_beers!
    Beer.import(beers_json, on_duplicate_key_update: [:id])
    UserBeer.import(
      user_beer_params,
      on_duplicate_key_update: { conflict_target: [:user_id, :beer_id] }
    )
  end

  def api_beers
    JSON.parse(RestClient.get("https://api.punkapi.com/v2/beers"), symbolize_names: true)
  end

  def beers_json
    api_beers.map do |row|
      row.slice(*beer_attribute_names)
    end
  end

  def user_beer_params
    beers_json.map do |row|
      result = {}
      result[:beer_id] = row[:id]
      result[:user_id] = @current_user.id
      result
    end
  end

  def api_beer
    json = RestClient.get("https://api.punkapi.com/v2/beers/#{params[:id]}")
    JSON.parse(json, symbolize_names: true).first.merge({seen_at: Time.current})
  end

  def update_beer!
    @_beer = Beer.find_or_create_by(id: api_beer[:id])
    @_beer.assign_attributes api_beer.slice(*beer_attribute_names)
    @_beer.save! if @_beer.changed?
    associate_beer!
  end

  def associate_beer!
    @beer = UserBeer.find_or_create_by!(user: @current_user, beer: @_beer)
  end

  def beer_attribute_names
    Beer.attribute_names.map(&:to_sym)
  end
end
