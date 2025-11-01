class Api::V1::RacesController < ApplicationController
  def index
    races = Dnd5eDataGateway.fetch_races.map { |race_data| RacePoro.new(race_data) }
    render json: RaceSerializer.new(races, params: { detailed: false }).serializable_hash
  end

  def show
    race = Dnd5eDataGateway.fetch_races(params[:id])
    if race
      render json: RaceSerializer.new(RacePoro.new(race), params: { detailed: true }).serializable_hash
    else
      render json: { error: "Race not found" }, status: :not_found
    end
  end
end
