class Api::V1::SubclassesController < ApplicationController
  def index
    subclasses = Dnd5eDataGateway.fetch_subclasses.map { |subclass_data| SubclassPoro.new(subclass_data) }
    render json: SubclassSerializer.new(subclasses, params: { detailed: false }).serializable_hash
  end

  def show
    subclass = SubclassPoro.new(Dnd5eDataGateway.fetch_subclasses(params[:id]))
    render json: SubclassSerializer.new(subclass, params: { detailed: true }).serializable_hash
  end
end
