class Api::V1::CharactersController < ApplicationController
  before_action :validate_id_format, only: [ :show, :update, :destroy ]
  before_action :set_character, only: [ :show, :update, :destroy ]

  def index
    characters = Character.all

    render json: CharacterSerializer.new(characters).serializable_hash
  end

  def show
    render json: CharacterSerializer.new(@character).serializable_hash
  end

  def create
    @character = Character.new(character_params)

    if @character.save
      render json: { message: "Character created successfully", data: character }, status: :created
    else
      render_param_errors
    end
  end

  def update
    if invalid_string_types?
      return render json: { error: detect_type_error }, status: :bad_request
    end

    if @character.update(character_params)
      render json: CharacterSerializer.new(@character).serializable_hash
    else
      render_param_errors
    end
  end

  def destroy
    @character.destroy

    head :no_content
  end

  private

  def set_character
    @character = Character.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Character not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:id].to_s.match?(/^\d+$/) && params[:id].to_i > 0
      render json: { error: "Invalid character ID" }, status: :bad_request
    end
  end

  def render_param_errors
    error = @character.errors.first
    attribute = error.attribute.to_s.humanize
    type = error.type

    case type
    when :taken
      message = "Character already exists with this #{attribute.downcase}"
      status = :unprocessable_content
    when :required
      message = "#{attribute} is required"
      status = :bad_request
    else
      message = error.full_message
      status = :bad_request
    end

    render json: { error: message }, status: status
  end

  def invalid_string_types?
    string_params = [ :name, :alignment, :background ]
    string_params.any? { |param| params[:character]&.key?(param) && !params[:character][param].is_a?(String) && params[:character][param].present? }
  end

  def detect_type_error
    return "Name is invalid" if params[:character][:name].present? && !params[:character][:name].is_a?(String)
    return "Alignment is invalid" if params[:character][:alignment].present? && !params[:character][:alignment].is_a?(String)
    "Background is invalid" if params[:character][:background].present? && !params[:character][:background].is_a?(String)
  end

  def character_params
    params.require(:character).permit(:name, :level, :experience_points, :alignment, :background, :user_id, :character_class_id, :race_id, :subclass_id, :subrace_id, languages: [])
  end
end
