require "spec_helper"

describe V2::GeocoderApi do
  let(:random_path) { "/v2/geocoder/random" }

  it "get a random place" do
    place = create :place
    scrip = create :scrip
    scrip.information.update place: place
    create_list :place, 2
    res = auth_json_get random_path, geolocation: "123,123"
    expect(res[:id]).to eq(place.id)
  end
end
