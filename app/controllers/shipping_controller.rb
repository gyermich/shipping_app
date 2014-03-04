class ShippingController < ApplicationController

  def index

    packages = Package.new( params[:packages][:weight].to_i * 16,  # lbs, times 16 oz/lb.
                            [ params[:packages][:length].to_i,     # LxWxH, inches
                              params[:packages][:width].to_i,
                              params[:packages][:height].to_i
                            ],
                            units: :imperial                  # not grams, not centimetres
                          )

    destination = Location.new( country:     params[:destination][:country],
                                province:    params[:destination][:province],
                                city:        params[:destination][:city],
                                postal_code: params[:destination][:postal_code].to_i )

    # @active_shipping_response = { hello: "your json" }
    @active_shipping_response = Shipping.ups_parsed_shipping(destination, packages)

    respond_to do |format|
      format.json { render json: @active_shipping_response, status: :ok  }
    end
  end



  


end
