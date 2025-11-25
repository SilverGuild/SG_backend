class Api::V1::SubclassesController < ApplicationController
  def index
    subclasses = Dnd5eDataGateway.fetch_subclasses.map { |subclass_data| SubclassPoro.new(subclass_data) }
    render json: SubclassSerializer.new(subclasses, params: { detailed: false }).serializable_hash
  end

  def show
    subclass = Dnd5eDataGateway.fetch_subclasses(params[:id])

    if subclass
      render json: SubclassSerializer.new(SubclassPoro.new(subclass), params: { detailed: true }).serializable_hash
    else
      render json: { error: "Subclass not found" }, status: :not_found
    end
  end
end
