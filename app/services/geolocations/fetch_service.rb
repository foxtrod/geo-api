require 'resolv'

module Geolocations
  class FetchService
    class InvalidQueryFormat < StandardError; end

    attr_accessor :query

    def initialize(query:)
      @query = query
    end

    def call
      raise InvalidQueryFormat unless validate_query

      geolocation = Geolocation.find_by('query = ? OR ip = ?', query, query)

      return success_response(geolocation) if geolocation

      geo_data = ::Ipstack.fetch!(query: query)

      geolocation = parse_geolocation(query: query, geo_data: geo_data)
      geolocation.save!

      success_response(geolocation)
    rescue ActiveRecord::RecordInvalid => e
      OpenStruct.new(success?: false, payload: e)
    rescue ActiveRecord::RecordNotUnique
      geolocation = Geolocation.find_by(ip: geo_data.ip)
      success_response(geolocation)
    rescue InvalidQueryFormat
      OpenStruct.new(success?: false, payload: 'Invalid query format. Please use valid IP or URL formats')
    rescue StandardError => e
      OpenStruct.new(success?: false, payload: e)
    end

    private

    def validate_query
      query =~ Regexp.union([::Resolv::IPv4::Regex, ::Resolv::IPv6::Regex]) || query =~ URI.regexp
    end

    def parse_geolocation(query:, geo_data:)
      geo = ::Geolocation.new(query: query)
      geo.attributes = {
        ip: geo_data.ip,
        city: geo_data.city,
        country: geo_data.country_name,
        zip: geo_data.country_name,
        latitude: geo_data.latitude,
        longitude: geo_data.longitude,
      }

      geo
    end

    def success_response(geolocation)
      OpenStruct.new(success?: true, payload: geolocation)
    end
  end
end
