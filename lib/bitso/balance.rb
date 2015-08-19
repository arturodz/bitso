module Bitso
  class Balance < Bitso::Model
    attr_accessor :btc_available, :btc_reserved, :btc_balance, :mxn_available, :mxn_reserved, :mxn_balance, :fee

    def self.from_api
      Bitso::Helper.parse_object!(Bitso::Net.post('/balance').to_str, self)
    end

    def self.method_missing method, *args
      balance = self.from_api
      return balance.send(method) if balance.respond_to? method

      super
    end
  end
end
