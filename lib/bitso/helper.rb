module Helper
  def precise(hash, decimal)
    num_data = ["rate", "mxn", "btc", "fee", "mxn_balance", "btc_balance",
      "mxn_reserved", "btc_reserved", "mxn_available", "btc_available",
      "amount", "price", "bid", "ask", "last", "high", "low", "vwap", "volume"]

    if decimal
      hash.each { |k, v| hash[k] = BigDecimal.new(v) if num_data.include? k.id2name }
    else
      hash.each { |k, v| hash[k] = v.to_f if num_data.include? k.id2name }
    end
  end

  def symbolize_keys(hash)
    hash.inject({}) { |result, (key, value)|
      new_key = case key when String then key.to_sym else key end
      new_value = case value when Hash then symbolize_keys(value) else value end

      result[new_key] = new_value
      result
    }
  end

  def structure_response(response, precision)
    if response.class == Hash
      result = precise(symbolize_keys response, precision)
      Struct.new(* result.keys).new(* result.values)
    elsif response.class == Array
      response = response.map do |r|
        result = precise(symbolize_keys r, precision)
        Struct.new(* result.keys).new(* result.values)
      end
    else
      response
    end
  end
end
