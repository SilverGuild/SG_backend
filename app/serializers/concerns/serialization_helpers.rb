module SerializationHelpers 
  extend ActiveSupport::Concern

  # Override serializable_hash to confirm id is int type when rendered
  def serializable_hash
    hash = super

    # Ensure data is an array
    hash[:data] = [ hash[:data] ] unless hash[:data].is_a?(Array)

    # Convert IDs to integers
    hash[:data].each { |item| item[:id] = item[:id].to_i }

    hash
  end
end