module Helper
  def floatify(hash)
    num_data = ["rate", "mxn", "btc", "fee", "mxn_balance", "btc_balance",
      "mxn_reserved", "btc_reserved", "mxn_available", "btc_available",
      "amount", "price", "bid", "ask", "last", "high", "low", "vwap", "volume"]

    hash.each { |k, v| hash[k] = v.to_f if num_data.include? k.id2name }
  end

  def symbolize_keys(hash)
    hash.inject({}) { |result, (key, value)|
      new_key = case key when String then key.to_sym else key end
      new_value = case value when Hash then symbolize_keys(value) else value end

      result[new_key] = new_value
      result
    }
  end

  def structure_response(response)
    if response.class == Hash
      result = floatify(symbolize_keys response)
      Struct.new(* result.keys).new(* result.values)
    elsif response.class == Array
      response = response.map do |r|
        result = floatify(symbolize_keys r)
        Struct.new(* result.keys).new(* result.values)
      end
    else
      response
    end
  end
end
