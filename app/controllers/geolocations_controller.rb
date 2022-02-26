class GeolocationsController < ApplicationController
  # GET /geolocations?query=192.168.0.0
  def show
    fetch_result = Geolocations::FetchService.new(query: params[:query]).call

    if fetch_result.success?
      render json: fetch_result.payload, status: :ok
    else
      render json: { errors: fetch_result.payload }, status: :unprocessable_entity
    end
  end

  # DELETE /geolocations?query=http://example.com
  def destroy
    @geolocation = Geolocation.find_by('query = ? OR ip = ?', params[:query], params[:query])

    return render json: { error: 'not found' }, status: :not_found unless @geolocation

    if @geolocation.destroy
      render json: :ok
    else
      render json: :error
    end
  end
end
