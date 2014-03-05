require 'spec_helper'
include ActiveMerchant::Shipping

describe ShippingController do
  context "when accessing :index" do

    it "renders index" do 
      packages = double(:package, width: 3, height: 2, length: 4, weight: 12)
      destination = double(:destination, country: "US", postal_code: "98101", city: "Seattle", province: "WA")

      described_class.stub(:package).and_return(packages)

      described_class.stub(:destination).and_return(destination)

      active_shipping_response = {shipping_hash: "it will never get there"}

      described_class.stub(:all_the_shipping).with(:destination, :packages).and_return(active_shipping_response)

      puts packages.inspect

      
      get :index
      expect(response).to be_success
    end
  end
end