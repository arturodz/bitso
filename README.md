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

If you want decimal precision you can pass the `decimal: true` parameter to the Bitso client.

```
client = Bitso.new(CLIENT, API_KEY, API_SECRET, decimal: true)
```

## Usage

### Current Trading Information


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b
my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
