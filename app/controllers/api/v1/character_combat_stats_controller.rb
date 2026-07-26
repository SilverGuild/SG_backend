class Api::V1::CharacterCombatStatsController < ApplicationController
  before_action :validate_id_format, only: [ :update, :destroy ]
  before_action :set_combat_stat, only: [ :update, :destroy ]

  def update
    if @combat_stat.update(combat_stat_params)
      render json: CharacterCombatStatsSerializer.new(@combat_stat).serializable_hash, status: :ok
    else
      render_param_errors(@combat_stat)
    end
  end

  def destroy
    @combat_stat.destroy
    head :no_content
  end

  private

  def set_combat_stat
    @combat_stat = CharacterCombatStats.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Combat Stat not found" }, status: :not_found
  end

  def validate_id_format
    unless params[:id].to_s.match?(/^\d+$/) && params[:id].to_i > 0
      render json: { error: "Invalid Combat Stat ID" }, status: :bad_request
    end
  end

  def render_param_errors(record)
    render json: { error: record.errors.full_messages.first }, status: :bad_request
  end

  def combat_stat_params
    params.require(:character_combat_stat).permit(:character_id, :current_hp, :temporary_hp, :max_hp, :hit_dice_remaining, :death_save_successes, :death_save_failures, :armor_class, :stable, conditions: [])
  end
end
