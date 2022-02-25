class Geolocation < ApplicationRecord
  validates :query,
            :ip,
            :longitude,
            :latitude,
            presence: true
end
