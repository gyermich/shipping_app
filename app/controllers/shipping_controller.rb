class ShippingController < ApplicationController

  def index

    packages = [
      Package.new(  100,                        # 100 grams
                    [93,10],                    # 93 cm long, 10 cm diameter
                    :cylinder => true),         # cylinders have different volume calculations

      Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
                    [15, 10, 4.5],              # 15x10x4.5 inches
                    :units => :imperial)        # not grams, not centimetres
    ]

      destination = Location.new( :country => 'CA',
                                  :province => 'ON',
                                  :city => 'Ottawa',
                                  :postal_code => 'K1P 1J1')

    # @active_shipping_response = { hello: "your json" }
    @active_shipping_response = Shipping.ups_parsed_shipping(destination, packages)

    respond_to do |format|
      format.json { render json: @active_shipping_response, status: :ok  }
    end
  end


  

end