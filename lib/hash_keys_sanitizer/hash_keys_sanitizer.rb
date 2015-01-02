class HashKeysSanitizer

  class HashKeysSanitizerError < StandardError
  end

  def initialize(options = {})
    @whitelist = options[:whitelist] || {}
  end

  ##
  # Sanitizes given hash and returns new hash.
  #
  def sanitize(raw_parameters = {})
    kept_params = {}
    sanitize_nesting(kept_params, @whitelist, symbolize_recursive(raw_parameters))
    kept_params
  end

  private

    def sanitize_nesting(kept_params, whitelist, raw_parameters)
      # example whitelist: [:name, address: [:street, :city, email: [:type]]]
      whitelist.each do |entry|
        # :name
        if entry.is_a?(Symbol) || entry.is_a?(String)
          key = entry.to_sym
          kept_params[key] = raw_parameters[key] if raw_parameters.has_key?(key)
        # { address: [:street, :city, ...] }
        elsif entry.is_a?(Hash)
          key = entry.keys.first.to_sym
          kept_params[key] ||= {}
          sanitize_nesting(kept_params[key], entry.values.first, raw_parameters[key])
        else
          raise HashKeysSanitizerError, "Unsupported whitelist entry type #{entry.class}: #{entry.inspect}"
        end
      end
    end

    def symbolize_recursive(hash)
      {}.tap do |h|
        hash.each { |key, value| h[key.to_sym] = map_value(value) }
      end
    end

    def map_value(thing)
      case thing
      when Hash
        symbolize_recursive(thing)
      when Array
        thing.map { |v| map_value(v) }
      else
        thing
      end
    end
end