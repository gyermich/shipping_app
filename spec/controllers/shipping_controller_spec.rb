require 'spec_helper'
include ActiveMerchant::Shipping

describe ShippingController do

  context "when accessing :index" do

    before do
      request.env['HTTP_ACCEPT'] = 'application/json'
    end

    let(:params) { {packages: {width: 3, height: 2, length: 4, weight: 12}, destination: {country: "US", postal_code: "98101", city: "Seattle", province: "WA"} } }

    it "renders index" do 

      active_shipping_response = {shipping_hash: "it will never get there"}

      described_class.stub(:all_the_shipping).with(:destination, :packages).and_return(active_shipping_response)
      
      post :index, params
      expect(response).to be_success
    end
  end
end