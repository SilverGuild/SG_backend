class Api::V1::CharacterClassesController < ApplicationController
  def index
    character_classes = Dnd5eDataGateway.fetch_character_classes.map { |char_class_data|  CharacterClassPoro.new(char_class_data) }
    render json: CharacterClassSerializer.new(character_classes, params: { detailed: false }).serializable_hash
  end

  def show
    character_class = Dnd5eDataGateway.fetch_character_classes(params[:id])

    if character_class
      render json: CharacterClassSerializer.new(CharacterClassPoro.new(character_class), params: { detailed: true }).serializable_hash
    else
      render json: { error: "Character class not found" }, status: :not_found
    end
  end
end
