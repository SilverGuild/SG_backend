class Api::V1::Characters::CharacterSkillsController < ApplicationController
  before_action :validate_id_format, only: [ :index, :create ]
  before_action :set_character, only: [ :index, :create ], if: -> { params[:character_id].present? }
  
  def index
    skills = @character.skills

    if skills.present?
      render json: CharacterSkillSerializer.new(skills).serializable_hash
    else
      render json: { error: "No skills were found for this character" }, status: :not_found
    end
  end

  def create
    @skill = @character.skills.build(skill_params)

    if @skill.save
      render json: { message: "Skill created successfully", data: @skill}, status: :created
    else
      render_param_errors
    end
  end

  private

  def set_character
    @character = Character.find(params[:character_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Character not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:character_id].to_s.match?(/^\d+$/) && params[:character_id].to_i > 0
      render json: { error: "Invalid character ID" }, status: :bad_request
    end
  end

  def render_param_errors
    error = @skill.errors.first
    attribute = error.attribute.to_s.humanize
    type = error.type

    case type
    when :taken
      message = "Skill already exists for this character"
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

  def skill_params
    params.require(:character_skill).permit(:skill_id, :proficient, :expertise).merge(character_id: @character.id)
  end
end
