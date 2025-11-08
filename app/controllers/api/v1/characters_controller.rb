class Api::V1::CharactersController < ApplicationController
  def index
    characters = Character.all

    render json: CharacterSerializer.new(characters).serializable_hash
  end

  def show
    character = Character.find(params[:id])

    render json: CharacterSerializer.new(character).serializable_hash
  end

  def create
    character = Character.create!(character_params)

    render json: { message: "Character created successfully", data: character }, status: :created
  end

  def update
    character = Character.find(params[:id])

    character.update(character_params)

    render json: CharacterSerializer.new(character).serializable_hash
  end

  def destroy
    character = Character.find(params[:id])

    character.destroy

    head :no_content
  end

  private

  def character_params
    params.require(:character).permit(:name, :level, :experience_points, :alignment, :background, :user_id, :character_class_id, :race_id, :subclass_id, :subrace_id, languages: [])
  end
end
