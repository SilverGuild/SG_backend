class Api::V1::Users::CharactersController < ApplicationController
  before_action :validate_id_format, only: [ :index, :create ]
  before_action :set_user, only: [ :index, :create ], if: -> { params[:user_id].present? }

  def index
    characters = @user.characters

    if characters.present?
      render json: CharacterSerializer.new(characters).serializable_hash
    else
      render json: { error: "No characters were found for this user" }, status: :not_found
    end
  end

  def create
    if invalid_string_types?
      return render json: { error: detect_type_error}, status: :bad_request
    end

    @character = @user.characters.build(character_params)

    if @character.save
      render json: { message: "Character created successfully!", data: @character }, status: :created
    else
      render_param_errors
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:user_id].to_s.match?(/^\d+$/) && params[:user_id].to_i > 0
      render json: { error: "Invalid user ID" }, status: :bad_request
    end
  end

  def render_param_errors
     error = @character.errors.where(:name, :blank).first ||
          @character.errors.where(:race_id, :blank).first ||
          @character.errors.where(:character_class_id, :blank).first ||
          @character.errors.first
    attribute = error.attribute.to_s.humanize
    type = error.type

    case type
    when :taken
      message = "Character already exists with this name"
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
    params.require(:character).permit(:name, :level, :experience_points, :alignment, :background, :character_class_id, :race_id, :subclass_id, :subrace_id, languages: []).merge(user_id: @user.id)
  end
end
