require 'rails_helper'

describe Geolocations::FetchService do
  subject { described_class.new(query: query).call }

  let(:query) { 'http://test.url' }

  context 'when geolocation already exists' do
    let!(:geolocation) { create(:geolocation) }

    context 'when query format is ip' do
      let(:query) { geolocation.ip }

      it 'returns geolocation' do
        result = subject

        expect(result.success?).to eq(true)
        expect(result.payload).to eq(geolocation)
      end
    end

    context 'when query format is url' do
      let(:query) { geolocation.query }

      it 'returns geolocation' do
        result = subject

        expect(result.success?).to eq(true)
        expect(result.payload).to eq(geolocation)
      end
    end

    context 'when query format is invalid' do
      let(:query) { 'invalid' }

      it 'returns geolocation' do
        result = subject

        expect(result.success?).to eq(false)
        expect(result.payload).to eq('Invalid query format. Please use valid IP or URL formats')
      end
    end
  end

  context 'when geolocation not found in db' do
    let(:response) { double(ip: "123.123.123.123", country_name: "China", city: "Beijing", latitude: 39, longitude: 116) }

    before do
      expect(Ipstack).to receive(:fetch!).with(query: query).and_return(response)
    end

    it 'returns geolocation with geoprovider data' do
      result = subject

      geolocation = Geolocation.find_by(ip: response.ip)
      expect(result.success?).to eq(true)
      expect(result.payload).to eq(geolocation)
    end
  end

  context 'when geolocation not found in external provider' do
    let(:query) { 'http://not.existing.url' }

    before do
      expect(Ipstack).to receive(:fetch!).with(query: query).and_raise(Ipstack::Api::DetailsNotFound, { detail: 'not found' })
    end

    it 'returns error' do
      result = subject

      expect(result.success?).to eq(false)
      expect(result.payload.class).to eq(Ipstack::Api::DetailsNotFound)
    end
  end
end
