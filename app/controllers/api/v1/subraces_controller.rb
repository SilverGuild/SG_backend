class Api::V1::SubracesController < ApplicationController
  def index
    subraces = Dnd5eDataGateway.fetch_subraces.map { |subrace_data| SubracePoro.new(subrace_data) }
    render json: SubraceSerializer.new(subraces, params: { detailed: false }).serializable_hash
  end

  def show
    subrace = Dnd5eDataGateway.fetch_subraces(params[:id])

    if subrace
      render json: SubraceSerializer.new(SubracePoro.new(subrace), params: { detailed: true }).serializable_hash
    else
      render json: { error: "Subrace not found" }, status: :not_found
    end
  end
end
