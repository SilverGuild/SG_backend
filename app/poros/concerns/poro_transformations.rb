module PoroTransformations
  def json_to_array(data, key_mapping = nil) # Transform an array json into a poro attribute which is an array of the hashes
    # If no mapping provided, auto-detect from the first hash
    key_mapping ||= auto_detect_mapping(data.first) if data.any?

    data.map do |hash|
      transformed = {}
      hash.each do |key, value|
        # Use mapped key or fallback on symbolized version
        new_key = key_mapping[key] || key.to_sym

        transformed[new_key] = value
      end
      transformed
    end
  end

  private

  def auto_detect_mapping(hash)
    mapping = {}
    hash.keys.each do |key|
      snake_key = to_snake_case(key)
      mapping[key] = snake_key unless key == snake_key
    end
    mapping 
  end

  def to_snake_case(key)
    string_key = key.to_s

    snake_case = string_key
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .downcase

    snake_case.to_sym
  end
end
