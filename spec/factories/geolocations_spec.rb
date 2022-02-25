FactoryBot.define do
  factory :geolocation do
    ip { '192.168.0.1' }
    query { 'http://localhost.test' }
    longitude { '50' }
    latitude { '-50' }
  end
end
