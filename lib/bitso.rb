require 'bitso/helper'

require 'typhoeus'
require 'openssl'
require 'base64'

class Bitso
  include Helper

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

    options.each { |k,v| payload[k] = v }; payload if options
	end

	def request(method, action, options)
		response = Typhoeus::Request.new(
      "#{@base_url}#{action}",
		  method: method,
			body: payload(options).to_json,
			headers: { "Content-Type" => "application/json" }
    ).run

		structure_response(JSON.parse(response.body, quirks_mode: true))
  end

	# Public Functions

  public_functions = ["ticker", "orders", "transactions"]

  public_functions.each do |action|
	  define_method(action) do |options={}|
      request :get, action, options
  	end
  end

  # Private Functions

  private_functions = ["balance", "user_transactions", "open_orders",
    "lookup_order", "cancel_order", "buy", "sell", "bitcoin_deposit_address",
    "bitcoin_withdrawal", "ripple_withdrawal"]

  private_functions.each do |action|
  	define_method(action) do |options={}|
      request :post, action, options
  	end
  end
end
