class Api::V1::Users::CharactersController < ApplicationController
  before_action :set_user, only: [ :index, :create ], if: -> { params[:user_id].present? }

  def index
    characters = @user.characters
    render json: CharacterSerializer.new(characters).serializable_hash
  end

  def create
    character = @user.characters.build(character_params)
    if character.save
      render json: { message: "Character created successfully!", data: character }, status: :created
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def character_params
    params.permit(:name, :level, :experience_points, :alignment, :background, :character_class_id, :race_id, :subclass_id, :subrace_id)
  end
end
