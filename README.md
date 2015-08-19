# Bitso Ruby GEM

This is the official client library for the [Bitso API v2](https://bitso.com/api_info). We provide an intuitive, stable interface to integrate Bitso into your Ruby project.

## Installation

Add this line to your application's Gemfile:

    gem 'bitso'

Then execute:

    bundle install

Or install it yourself as:

    gem install bitso



## Authentication

### Create API Key

More info at: [https://bitso.com/api_setup](https://bitso.com/api_setup)

### Setup

```ruby
require 'bitso'
client = Bitso.new(CLIENT, API_KEY, API_SECRET)
```

Our API returns [Floats](http://ruby-doc.org/core-2.2.0/Float.html) by default. However, we recommend you override this option and use [BigDecimals](http://ruby-doc.org/stdlib-1.9.3/libdoc/bigdecimal/rdoc/BigDecimal.html) instead to avoid loss of precision. In order to do this, you can pass the `precision: true` parameter to the Bitso client:

```ruby
require 'bitso'
client = Bitso.new(CLIENT, API_KEY, API_SECRET, precision: true)
```

## Usage
=======

### Ticker

The Bitso ticker. Returns `last`, `high`, `low`, `volume`, `bid` and `ask`

```ruby
client.ticker
```

```ruby
client.ticker.low     # => "3500.17"
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b
my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
