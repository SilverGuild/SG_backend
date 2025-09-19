class Api::V1::RacesController < ApplicationController
  def index
    races = Race.all

    render json: RaceSerializer.new(races).serializable_hash
  end
end
