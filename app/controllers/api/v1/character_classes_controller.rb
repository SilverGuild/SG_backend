class Api::V1::CharacterClassesController < ApplicationController
  def index
    character_classes = CharacterClass.all

    render json: CharacterClassSerializer.new(character_classes).serializable_hash
  end
end