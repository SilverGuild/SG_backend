class UserSerializer
  include JSONAPI::Serializer

  attributes  :username,
              :email

  # Override serializable_hash to confirm id is int type when rendered
  def serializable_hash
    hash = super

    hash[:data] = [ hash[:data] ] unless hash[:data].is_a?(Array)
    hash[:data].each { |item| item[:id] = item[:id].to_i }

    hash
  end
end
