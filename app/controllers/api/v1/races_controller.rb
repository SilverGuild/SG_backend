class Api::V1::RacesController < ApplicationController
  def index
    races = Race.all

    render json: RaceSerializer.new(races).serializable_hash
  end

  def show
    race = Race.find(params[:id])

    render json: RaceSerializer.new(race).serializable_hash
  end
end
