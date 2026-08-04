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
      return render json: { error: detect_type_error }, status: :bad_request
    end

    result = CharacterBuilder.new(
      user: @user,
      character_params: character_params,
      ability_scores_params: ability_scores_params,
      skills_params: skills_params,
      combat_stats_params: combat_stats_params
    ).call

    @character = result.character

    if result.success?
      render json: aggregate_character_response(@character), status: :created
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

  def aggregate_character_response(character)
    response = CharacterSerializer.new(character).serializable_hash
    character_data = response[:data].first

    character_data[:attributes][:ability_scores] = character.ability_scores.map { |a| attributes_for(CharacterAbilityScoreSerializer, a) }
    character_data[:attributes][:skills] = character.skills.map { |s| attributes_for(CharacterSkillSerializer, s) }
    character_data[:attributes][:combat_stats] = character.combat_stats ? attributes_for(CharacterCombatStatsSerializer, character.combat_stats) : nil

    response
  end

  def attributes_for(serializer_class, record)
    serializer_class.new(record).serializable_hash[:data].first[:attributes]  end

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
    when :required, :blank
      message = "#{attribute} can't be blank"
      status = :bad_request
    else
      message = error.full_message
      status = :bad_request
    end

    render json: { error: message }, status: status
  end

  def friendly_attribute_label(attribute)
    attribute_str = attribute.to_s

    if (match = attribute_str.match(/\A\w+\[\d+\]\.(\w+)\z/))
      match[1].humanize
    elsif (match = attribute_str.match(/\A\w+\.(\w+)\z/))
      match[1].humanize
    else
      attribute_str.humanize
    end
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
    params.require(:character).permit(:name, :level, :experience_points, :alignment, :background, :character_class_id, :race_id, :subclass_id, :subrace_id, languages: [])
  end

  def ability_scores_params
    params.fetch(:ability_scores, []).map do |ability_score|
      ability_score.permit(:ability_id, :score, :saving_throw_proficient)
    end
  end

  def skills_params
    params.fetch(:skills, []).map do |skill|
      skill.permit(:skill_id, :proficient, :expertise)
    end
  end

  def combat_stats_params
    params.fetch(:combat_stats, {}).permit(:current_hp, :max_hp, :temporary_hp, :hit_dice_remaining, :death_save_successes, :death_save_failures, :stable, :armor_class, conditions: [])
  end
end
