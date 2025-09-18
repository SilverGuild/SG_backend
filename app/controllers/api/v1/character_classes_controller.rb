class Api::V1::CharacterClassesController < ApplicationController
  def index
    character_classes = CharacterClass.all

    render json: CharacterClassSerializer.new(character_classes).serializable_hash
  end

  def show
    character_class = CharacterClass.find(params[:id])

    render json: CharacterClassSerializer.new(character_class).serializable_hash
  end
end
