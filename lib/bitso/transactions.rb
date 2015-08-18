module Bitso
  class UserTransactions < Bitso::Collection
    def all(options = {})
      # Default time delta to an hour
      options[:timedelta] = "3600" unless options[:timedelta]

      Bitso::Helper.parse_objects! Bitso::Net::post("/user_transactions", options).to_str, self.model
    end

    def find(order_id)
      all = self.all
      index = all.index {|order| order.id.to_i == order_id}

      return all[index] if index
    end

    def create(options = {})
    end

    def update(options={})
    end
  end

  class UserTransaction < Bitso::Model
    attr_accessor :datetime, :id, :type, :mxn, :btc, :fee, :order_id, :btc_mxn, :nonce, :rate
  end

  # adding in methods to pull the last public trades list
  class Transactions < Bitso::Model
    attr_accessor :date, :price, :tid, :amount

    def self.from_api
      Bitso::Helper.parse_objects! Bitso::Net::get("/transactions").to_str, self
    end

  end
end
