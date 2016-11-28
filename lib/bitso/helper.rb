module Helper
  def re_hash(hash, precise)
    num_data = ["rate", "mxn", "btc", "fee", "mxn_balance", "btc_balance",
      "mxn_reserved", "btc_reserved", "mxn_available", "btc_available",
      "amount", "price", "bid", "ask", "last", "high", "low", "vwap", "volume"]

    hash.each do |k,v|
      if num_data.include? k.id2name
        hash[k] = precise ? BigDecimal.new(v) : v.to_f
      end
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

  def structure_response(response, precise)
    if response.class == Hash
      result = re_hash(symbolize_keys(response), precise)
      Struct.new(* result.keys).new(* result.values)
    elsif response.class == Array
      response = response.map do |r|
        result = re_hash(symbolize_keys(r), precise)
        Struct.new(* result.keys).new(* result.values)
      end
    else
      response
    end
  end
end
