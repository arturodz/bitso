# Bitso Ruby API


## Installation

Add this line to your application's Gemfile:

    gem 'bitso'

## Create API Key

More info at: [https://bitso.com/api_info](https://bitso.com/api_info)

## Setup

```ruby
Bitso.setup do |config|
  config.key = YOUR_API_KEY
  config.secret = YOUR_API_SECRET
  config.client_id = YOUR_BITSO_USERNAME
end
```

If you fail to set your `key` or `secret` or `client_id` a `MissingConfigExeception`
will be raised.

## Bitso ticker

The Bitso ticker. Returns `last`, `high`, `low`, `volume`, `bid` and `ask`

```ruby
Bitso.ticker
```

It's also possible to query through the `Bitso::Ticker` object with
each individual method.

```ruby
Bitso::Ticker.low     # => "109.00"
```

## Fetch your open order

Returns an array with your open orders.

```ruby
Bitso.orders.all
```

## Create a sell order

Returns an `Order` object.

```ruby
Bitso.orders.sell(amount: 1.0, price: 111)
```

## Create a buy order

Returns an `Order` object.

```ruby
Bitso.orders.buy(amount: 1.0, price: 111)
```

## Fetch your transactions

Returns an `Array` of `UserTransaction`.

```ruby
Bitso.user_transactions.all
```

## Get your Bitcoin deposit address

Returns a `String` with your BTC deposit address

```ruby
Bitso.bitcoin_deposit_address
```

## Withdraw Bitcoins

Returns a `Boolean` indicating whether the withdrawal was successful or not

```ruby
Bitso.withdraw_bitcoins(amount: 1.23456789, address: "16Gcsethp9NdCt7oQaBaFS37hWX6nWafJL")
```

*To be continued!**

# Tests

If you'd like to run the tests you need to set the following environment variables:

```
export BITSO_KEY=xxx
export BITSO_SECRET=yyy
export BITSO_CLIENT_ID=zzz
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b
my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Credits

This is a fork of the [Bitstamp gem](https://github.com/kojnapp/bitstamp) built by [kojnapp](https://github.com/kojnapp).
