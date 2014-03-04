class Shipping
  include ActiveMerchant::Shipping

  def self.ups_api
    UPS.new(login:    'ada_shipping00', 
            password: Figaro.env.ups_password, 
            key:      Figaro.env.ups_key)
  end

  def self.fedex_api
    FedEx.new(account:    Figaro.env.fedex_test_account_number,
            password:   Figaro.env.fedex_test_password,
            key:        Figaro.env.fedex_test_key,
            login:      Figaro.env.fedex_test_meter_number,
            test:       true)
  end
  
  def self.get_shipping(destination, packages, api)
    origin = Location.new(country: 'US',
                          state:   'WA',
                          city:    'Seattle',
                          zip:     '98101')
    api.find_rates(origin, destination, packages)
  end

  def self.parsed_shipping(destination, packages, api)
    get_shipping(destination, packages, api).rates.sort_by(&:price).collect {|rate| { shipping_service: rate.service_name, price_in_cents: rate.price }}
  end

  def self.all_the_shipping(destination, packages)
    { ups: parsed_shipping(destination, packages, ups_api), fedex: parsed_shipping(destination, packages, fedex_api)}
  end
end