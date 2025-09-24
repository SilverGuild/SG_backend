class Api::V1::CharactersController < ApplicationController
  def index
    characters = Character.all

    render json: CharacterSerializer.new(characters).serializable_hash
  end
end