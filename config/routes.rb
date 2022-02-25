Rails.application.routes.draw do
  resource :geolocations, only: [:show, :create, :destroy]
end
