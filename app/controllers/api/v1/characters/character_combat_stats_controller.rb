class Api::V1::Characters::CharacterCombatStatsController < ApplicationController
  before_action :validate_id_format, only: [ :show, :create ]
  before_action :set_character, only: [ :show, :create ], if: -> { params[:character_id].present? }

  def show
    stats = @character.combat_stats
    
    if stats.present?
      render json: CharacterCombatStatsSerializer.new(stats).serializable_hash
    else
      render json: { error: "Combat Stats not found" }, status: :not_found
    end
  end

  def create
    if @character.combat_stats.present?
      render json: { "error" => "Combat Stat already exists for this character"}, status: :unprocessable_content
      return
    end

    @stats = @character.build_combat_stats(combat_stat_params)

    if @stats.save
      render json: CharacterCombatStatsSerializer.new(@stats).serializable_hash, status: :created
    else
      render_param_errors(@stats)
    end
  end

  private

  def validate_id_format
    unless params[:character_id].to_s.match?(/^\d+$/) && params[:character_id].to_i > 0
      render json: { error: "Invalid character ID" }, status: :bad_request
    end
  end

  def set_character
     @character = Character.find(params[:character_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Character not found" }, status: :not_found
  end

  def render_param_errors(record)
    # require "pry"; binding.pry
    render json: { error: record.errors.full_messages.first }, status: :bad_request
  end

  def combat_stat_params
    params.require(:character_combat_stat).permit(:current_hp, :temporary_hp, :max_hp, :hit_dice_remaining, :death_save_successes, :death_save_failures, :armor_class, :stable, conditions: []).merge(character_id: @character.id)
  end
end
