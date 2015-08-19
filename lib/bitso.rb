require 'typhoeus'
require 'openssl'
require 'base64'

class Bitso
	def initialize(client, key, secret)
		@client = client
		@key = key
		@secret = secret
		@base_url = 'https://api.bitso.com/v2/'
	end

	def payload(options = {})
		nonce = (Time.now.to_f*10000).to_i.to_s
		signature = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha256'), @secret, (nonce + @client + @key))
		payload = {
			key: @key,
			nonce: nonce,
			signature: signature.upcase
		}

    options.each { |k,v| payload[k] = v } if options
    payload
	end

	def request(method, action, options)
		request = Typhoeus::Request.new(
      "#{@base_url}#{action}",
		  method: method,
			body: payload(options).to_json,
			headers: { "Content-Type" => "application/json" }
    )

		response = request.run
		response = JSON.parse(response.body, quirks_mode: true)

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

  def floatify hash
    num_data = ["rate", "mxn", "btc", "fee", "mxn_balance", "btc_balance",
      "mxn_reserved", "btc_reserved", "mxn_available", "btc_available",
      "amount", "price"]

    hash.each { |k, v| hash[k] = v.to_f if num_data.include? k.id2name }
  end

  def symbolize_keys(hash)
    hash.inject({}){|result, (key, value)|
      new_key = case key
      when String then key.to_sym else key
      end

      new_value = case value
      when Hash then symbolize_keys(value) else value
      end

      result[new_key] = new_value
      result
    }
  end

	# Public Functions

  public_functions = ["ticker", "orders", "transactions"]

  public_functions.each do |action|
	  define_method(action) do |options={}|
      result = request :get, action, options
  	end
  end

  # Private Functions

  private_functions = ["balance", "user_transactions", "open_orders",
    "lookup_order", "cancel_order", "buy", "sell", "bitcoin_deposit_address",
    "bitcoin_withdrawal", "ripple_withdrawal"]

  private_functions.each do |action|
  	define_method(action) do |options={}|
      result = request :post, action, options
  	end
  end
end
