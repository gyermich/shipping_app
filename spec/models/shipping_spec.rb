require 'spec_helper'
include ActiveMerchant::Shipping

describe Shipping do
  describe "UPS get shipping" do
    context "shipping to Sacremento" do
      let(:destination) { Location.new(country: 'US',
                          state:   'CA',
                          city:    'Sacramento',
                          zip:     '95814') }

      let(:packages) { [ Package.new(  100,                        # 100 grams
                    [93,10],                    # 93 cm long, 10 cm diameter
                    :cylinder => true)] }

      it "returns at least one result" do
        ups_api = double(:ups_api)
        described_class.stub(:ups_api).and_return(ups_api)
        ups_api.should_receive(:find_rates).with(anything, :destination, :packages)
        results = described_class.ups_get_shipping(:destination, :packages)
      end

      it "REMOTE returns at least one result" do
        results = described_class.ups_get_shipping(destination, packages)
        expect(results).to_not be_empty
      end
    end
  end
end