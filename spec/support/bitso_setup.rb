RSpec.configure do |config|
  config.before(:each) do
    # The famous singleton problem
    Bitso.setup do |config|
      config.key = nil
      config.secret = nil
      config.client_id = nil
    end
  end
end

def setup_bitso
  Bitso.setup do |config|
    raise "You must set environment variable BITSO_KEY and BITSO_SECRET with your username and password to run specs." if ENV['BITSO_KEY'].nil? or ENV['BITSO_SECRET'].nil?
    config.key = ENV['BITSO_KEY']
    config.secret = ENV['BITSO_SECRET']
    config.client_id = ENV['BITSO_CLIENT_ID']
  end
end
