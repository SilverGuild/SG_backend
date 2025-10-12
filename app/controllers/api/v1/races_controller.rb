class Api::V1::RacesController < ApplicationController
  def index
    races = Dnd5eDataGateway.fetch_races.map { |race_data| RacePoro.new(race_data) }
    render json: RaceSerializer.new(races, params: {detailed: false}).serializable_hash
  end
  
  def show
    race = RacePoro.new( Dnd5eDataGateway.fetch_races( params[:id] ) )
    render json: RaceSerializer.new(race, params: {detailed: true}).serializable_hash
  end
end
