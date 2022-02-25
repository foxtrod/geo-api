module Ipstack
  def self.fetch!(query:)
    Ipstack::Api.new.fetch!(query: query)
  end
end
