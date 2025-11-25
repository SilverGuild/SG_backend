class SubclassPoro
  include PoroTransformations

  attr_reader :id,
              :class_id,
              :name,
              :flavor,
              :description,
              :url

  def initialize(subclass_data)
    @id           = subclass_data[:index]
    @class_id     = subclass_data.dig(:class, :index)
    @name         = subclass_data[:name]
    @flavor       = subclass_data[:subclass_flavor]
    @description  = subclass_data[:desc]&.first
    @url          = subclass_data[:url]
  end
end
