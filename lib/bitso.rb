require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'active_model'
require 'rest-client'

require 'bitso/net'
require 'bitso/helper'
require 'bitso/collection'
require 'bitso/model'
require 'bitso/balance'
require 'bitso/orders'
require 'bitso/transactions'
require 'bitso/ticker'

String.send(:include, ActiveSupport::Inflector)

module Bitso
  # API Key
  mattr_accessor :key

  # Bitso secret
  mattr_accessor :secret

  # Bitso client ID
  mattr_accessor :client_id

  # Currency
  mattr_accessor :currency
  @@currency = :mxn

  def self.orders
    self.sanity_check!

    @@orders ||= Bitso::Orders.new
  end

  def self.user_transactions
    self.sanity_check!

    @@transactions ||= Bitso::UserTransactions.new
  end

  def self.transactions
    return Bitso::Transactions.from_api
  end

  def self.balance
    self.sanity_check!
    return Bitso::Balance.from_api
  end

  def self.withdraw_bitcoins(options = {})
    self.sanity_check!
    if options[:amount].nil? || options[:address].nil?
      raise MissingConfigExeception.new("Required parameters not supplied, :amount, :address")
    end
    response_body = Bitso::Net.post('/bitcoin_withdrawal',options)
    if response_body != '"ok"'
      $stderr.puts "Withdraw Bitcoins Error: " + response_body
      return false
    end
    return true
  end

  def self.bitcoin_deposit_address
    # returns the deposit address
    self.sanity_check!
    address = Bitso::Net.post('/bitcoin_deposit_address')
    return address[1..address.length-2]
  end

  def self.ticker
    return Bitso::Ticker.from_api
  end

  def self.order_book
    return JSON.parse Bitso::Net.get('/order_book').to_str
  end

  def self.setup
    yield self
  end

  def self.configured?
    self.key && self.secret && self.client_id
  end

  def self.sanity_check!
    unless configured?
      raise MissingConfigExeception.new("Bitso Gem not properly configured")
    end
  end

  class MissingConfigExeception<Exception;end;
end
