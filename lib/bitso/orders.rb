module Bitso
  class Orders < Bitso::Collection
    def all(options = {})
      Bitso::Helper.parse_objects! Bitso::Net::post('/open_orders').to_str, self.model
    end

    def create(options = {})
      path = (options[:type] == Bitso::Order::SELL ? "/sell" : "/buy")
      Bitso::Helper.parse_object! Bitso::Net::post(path, options).to_str, self.model
    end

    def sell(options = {})
      options.merge!({type: Bitso::Order::SELL})
      self.create options
    end

    def buy(options = {})
      options.merge!({type: Bitso::Order::BUY})
      self.create options
    end

    def find(order_id)
      all = self.all
      index = all.index {|order| order.id.to_i == order_id}

      return all[index] if index
    end
  end

  class Order < Bitso::Model
    BUY  = 0
    SELL = 1

    attr_accessor :type, :amount, :price, :id, :datetime
    attr_accessor :error, :message

    def cancel!
      Bitso::Net::post('/cancel_order', {id: self.id}).to_str
    end
  end
end
