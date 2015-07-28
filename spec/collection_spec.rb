require 'spec_helper'

class Bitso::Coin < Bitso::Model;end
class Bitso::Coins < Bitso::Collection;end

describe Bitso::Coins do
  subject { Bitso::Coins.new }
  its(:name) { should eq 'coin' }
  its(:module) { should eq "bitso/coin" }
  its(:model) { should be Bitso::Coin }
  its(:path) { should eq "/api/coins" }
end
