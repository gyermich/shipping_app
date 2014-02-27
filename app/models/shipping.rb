class Shipping
  include ActiveMerchant::Shipping

  def setup_api(service)
    case service
    when "ups"
      ups_api
    when "fedex"
      fedex_api
    end
  end

  def self.ups_api
    UPS.new(login:    'ada_shipping00', 
            password: ENV["UPS_USER_PASSWORD"], 
            key:      ENV["UPS_KEY"])
  end

  def self.ups_get_shipping(destination, packages)
    origin = Location.new(country: 'US',
                          state:   'WA',
                          city:    'Seattle',
                          zip:     '98101')

    ups_api.find_rates(origin, destination, packages)
  end

  def self.ups_parsed_shipping(destination, packages)
    ups_get_shipping(destination, packages).rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      # does get_shipping need to be called on self

      # shipping_hash = { shipping_type: rate.service_name,
      #                   shipping_price: rate.price }
  end
end

    # packages = [
    #   Package.new(  100,                        # 100 grams
    #                 [93,10],                    # 93 cm long, 10 cm diameter
    #                 :cylinder => true),         # cylinders have different volume calculations

    #   Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
    #                 [15, 10, 4.5],              # 15x10x4.5 inches
    #                 :units => :imperial)        # not grams, not centimetres
    # ]

    #   destination = Location.new( :country => 'CA',
    #                           :province => 'ON',
    #                           :city => 'Ottawa',
    #                           :postal_code => 'K1P 1J1')