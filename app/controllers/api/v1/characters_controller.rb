class Api::V1::CharactersController < ApplicationController
  def index
    characters = Character.all

    render json: CharacterSerializer.new(characters).serializable_hash
  end

  def show
    character = Character.find(params[:id])

    render json: CharacterSerializer.new(character).serializable_hash
  end
end