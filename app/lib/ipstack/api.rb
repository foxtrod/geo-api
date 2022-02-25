module Ipstack
  Response = Struct.new(:ip, :country_name, :city, :zip, :latitude, :longitude, keyword_init: true)

  class Api
    HOST = 'http://api.ipstack.com'
    class NetworkError < StandardError; end
    class RequestError < StandardError; end
    class DetailsNotFound < StandardError; end

    def fetch!(query:)
      response = client.get("#{HOST}/#{query}", params: { access_key: ENV['IPSTACK_API_KEY'] })
      raise NetworkError, response unless response.status.success?

      data = JSON.parse(response)

      raise DetailsNotFound, data if data['detail'] == 'Not Found'

      raise RequestError, data['error']['info'] if data['error']

      parse(data)
      #dummy data
      # Response.new(ip: "123.123.123.123",
      #              country_name: "China",
      #              city: "Beijing",
      #              latitude: 39.91175842285156,
      #              longitude: 116.37922668457031)
    end

    private

    def client
      HTTP.timeout(10)
    end

    def parse(data)
      Response.new(
        ip: data['ip'],
        country_name: data['country_name'],
        city: data['city'],
        zip: data['zip'],
        latitude: data['latitude'],
        longitude: data['longitude']
      )
    end
  end
end
