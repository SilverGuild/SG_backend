class Api::V1::SubracesController < ApplicationController
  def index
    subraces = Dnd5eDataGateway.fetch_subraces.map { |subrace_data| SubracePoro.new(subrace_data) }
    render json: SubraceSerializer.new(subraces, params: { detailed: false }).serializable_hash
  end

  def show
    subrace = SubracePoro.new(Dnd5eDataGateway.fetch_subraces(params[:id]))
    render json: SubraceSerializer.new(subrace, params: { detailed: true }).serializable_hash
  end
end
