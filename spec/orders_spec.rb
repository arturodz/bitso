require 'spec_helper'

describe Bitso::Orders do
  before { setup_bitso }

  describe :all, vcr: {cassette_name: 'bitso/orders/all'} do
    subject { Bitso.orders.all }
    it { should be_kind_of Array }
    describe "first order" do
      subject { Bitso.orders.all.first }
      its(:price) { should == "1.01" }
      its(:amount) { should == "1.00000000" }
      its(:type) { should == 0 }
      its(:datetime) { should == "2013-09-26 23:15:04" }
    end
  end

  describe :sell do
    context "no permission found", vcr: {cassette_name: 'bitso/orders/sell/failure'} do
      subject { Bitso.orders.sell(:amount => 1, :price => 1000) }
      it { should be_kind_of Bitso::Order }
      its(:error) { should == "No permission found" }
    end
    # context "bitcoins available", vcr: {cassette_name: 'bitso/orders/sell/success'} do
    #   subject { Bitso.orders.sell(:amount => 1, :price => 1000) }
    #   xit { should be_kind_of Bitso::Order }
    #   its(:error) { should be_nil }
    # end
  end

  describe :buy, vcr: {cassette_name: 'bitso/orders/buy'} do
    subject { Bitso.orders.buy(:amount => 1, :price => 1.01) }
    it { should be_kind_of Bitso::Order }
    its(:price) { should == "1.01" }
    its(:amount) { should == "1" }
    its(:type) { should == 0 }
    its(:datetime) { should == "2013-09-26 23:26:56.849475" }
    its(:error) { should be_nil }
  end
end
