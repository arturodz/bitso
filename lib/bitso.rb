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
		sign_string = (nonce + @client + @key)
		signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, sign_string)
		payload = {
			key: @key,
			nonce: nonce,
			signature: signature.upcase
		}

		if options
			options.each do |k,v|
				payload[k] = v
			end
		end

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
      response = symbolize_keys response
    elsif response.class == Array
      response = response.map { |r| symbolize_keys r }
    else
      response
    end
  end

  def symbolize_keys(hash)
    hash.inject({}){|result, (key, value)|
      new_key = case key
      when String then key.to_sym
      else key
      end

      new_value = case value
      when Hash then symbolize_keys(value)
      else value
      end

      result[new_key] = new_value
      result
    }
  end

	# Public Functions

	def ticker(options={})
		response = JSON.parse(Typhoeus.get("https://api.bitso.com/v2/ticker?book=btc_mxn").body)
	end

	def orders(options={})
		request :get, "order_book", options
	end

	def transactions(options={})
		request :get, "transactions", options
	end

	# Private Functions

	def balance(options={})
		request :post, "balance", options
	end

	def user_transactions(options={})
		request :post, "user_transactions", options
	end

	def open_orders(options={})
		request :post, "open_orders", options
	end

	def lookup_order(options={})
		request :post, "lookup_order", options
	end

	def cancel_order(options={})
		request :post, "cancel_order", options
	end

	def buy(options={})
		request :post, "buy", options
	end

	def sell(options={})
		request :post, "sell", options
	end

  def bitcoin_deposit_address(options={})
    request :post, "bitcoin_deposit_address", options
  end

  def bitcoin_withdrawal(options={})
    request :post, "bitcoin_withdrawal", options
  end

  def ripple_withdrawal(options={})
    request :post, "ripple_withdrawal", options
  end
end
