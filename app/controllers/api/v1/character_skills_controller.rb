class Api::V1::CharacterSkillsController < ApplicationController
  before_action :validate_id_format, only: [ :update, :destroy ]
  before_action :set_skill, only: [ :update, :destroy ]

  def update
    if @skill.update(skill_params)
      render json: CharacterSkillSerializer.new(@skill).serializable_hash
    else
      render_param_errors
    end
  end

  def destroy
    @skill.destroy

    head :no_content
  end

  private

  def set_skill
    @skill = CharacterSkill.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Skill not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:id].to_s.match?(/^\d+$/) && params[:id].to_i > 0
      render json: { error: "Invalid skill ID"}, status: :bad_request
    end
  end

  def render_param_errors
    error = @skill.errors.first
    attribute = error.attribute.to_s.humanize
    type = error.type

    case type
    when :taken
      message = "Skill already exists with this #{attribute.downcase}"
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
    params.require(:character_skill).permit(:skill_id, :character_id, :proficient, :expertise)
  end
end
