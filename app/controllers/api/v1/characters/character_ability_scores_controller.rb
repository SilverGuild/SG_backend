class Api::V1::Characters::CharacterAbilityScoresController < ApplicationController
  before_action :validate_id_format, only: [ :index, :create ]
  before_action :set_character, only: [ :index, :create ], if: -> { params[:character_id].present? }

  def index
    ability_scores = @character.ability_scores

    if ability_scores.present?
      render json: CharacterAbilityScoreSerializer.new(ability_scores).serializable_hash
    else
      render json: { error: "No ability scores were found for this character" }, status: :not_found
    end
  end

  def create
    @ability_score = @character.ability_scores.build(ability_score_params)

    if @ability_score.save
      render json: CharacterAbilityScoreSerializer.new(@ability_score).serializable_hash, status: :created
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
    error = @ability_score.errors.first
    attribute = attribute_label(error.attribute)
    type = error.type

    case type
    when :taken
      message = "Ability Score already exists for this character"
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
    params.require(:character_ability_score).permit(:ability_id, :score, :saving_throw_proficient).merge(character_id: @character.id)
  end
end
