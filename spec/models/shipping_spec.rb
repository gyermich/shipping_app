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

      it "executes the .find_rates method" do
        api = double(:ups_api)
        described_class.stub(:ups_api).and_return(api)

        api.should_receive(:find_rates).with(anything, :destination, :packages)
        
        results = described_class.get_shipping(:destination, :packages, api)
      end

      xit "REMOTE returns at least one result" do
        api = UPS.new(login:                  'ada_shipping00', 
            password: Figaro.env.ups_password,
            key:      Figaro.env.ups_key)

        results = described_class.parsed_shipping(destination, packages, api)
        expect(results).to be_an_instance_of(Array)
      end

      xit "REMOTE returns at least one result" do

        api = UPS.new(login:                  'ada_shipping00', 
            password: Figaro.env.ups_password,
            key:      Figaro.env.ups_key)

        results = described_class.parsed_shipping(destination, packages, api)
        expect(results).to_not be_empty
      end

      it " is parsable" do
        api = double(:ups_api)
        described_class.stub(:ups_api).and_return(api)

        r = double(:ups_response)
        ship_rates = double(:something, :price => 1, :service_name => "standard")

        puts ship_rates.inspect

        api.should_receive(:find_rates).and_return(r)

        Shipping.stub(:ups_get_shipping).with(destination, packages, api) { r }
        expect(r).to receive(:rates) { [ship_rates] }
        expect(Shipping.parsed_shipping(destination, packages, api)).to be_an_instance_of(Array)
      end

      it "gets UPS and fedex shiping options" do

        expect(Shipping.all_the_shipping(destination, packages).length).to eq(2)
      end

    end


  end
end