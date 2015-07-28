module Bitso
  module Net
    def self.to_uri(path)
      return "https://api.bitso.com/v2#{path}/"
    end

    def self.get(path, options={})
      RestClient.get(self.to_uri(path))
    end

    def self.post(path, options={})
      RestClient.post(self.to_uri(path), self.Bitso_options(options))
    end

    def self.patch(path, options={})
      RestClient.put(self.to_uri(path), self.Bitso_options(options))
    end

    def self.delete(path, options={})
      RestClient.delete(self.to_uri(path), self.Bitso_options(options))
    end

    def self.Bitso_options(options={})
      if Bitso.configured?
        options[:key] = Bitso.key
        options[:nonce] = (Time.now.to_f*10000).to_i.to_s
        options[:signature] = HMAC::SHA256.hexdigest(Bitso.secret, options[:nonce]+Bitso.client_id.to_s+options[:key]).upcase
      end

      options
    end
  end
end
