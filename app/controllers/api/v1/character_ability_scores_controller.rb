class Api::V1::CharacterAbilityScoresController < ApplicationController
  before_action :validate_id_format, only: [ :update, :destroy ]
  before_action :set_ability_score, only: [ :update, :destroy ]

  def update
    if @ability_score.update(ability_score_params)
      render json: CharacterAbilityScoreSerializer.new(@ability_score).serializable_hash
    else
      render_param_errors
    end
  end

  def destroy
    @ability_score.destroy

    head :no_content
  end

  private

  def set_ability_score
    @ability_score = CharacterAbilityScore.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ability Score not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:id].to_s.match?(/^\d+$/) && params[:id].to_i > 0
      render json: { error: "Invalid Ability Score ID" }, status: :bad_request
    end
  end

  def render_param_errors
    error = @ability_score.errors.first
    attribute = attribute_label(error.attribute)
    type = error.type

    case type
    when :taken
      message = "Ability Score already exists with this #{attribute.downcase}"
      status = :unprocessable_content
    when :required
      message = "#{attribute} is required"
      status = :bad_request
    else
      message = "#{error.full_message}"
      status = :bad_request
    end
    render json: { error: message }, status: status
  end

  def attribute_label(attribute)
    { ability_id: "Ability Score" }[attribute] || attribute.to_s.humanize
  end

  def ability_score_params
    params.require(:character_ability_score).permit(:ability_id, :character_id, :score, :saving_throw_proficient)
  end
end
