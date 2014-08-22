require "rails_helper"

describe V2::MerchantsApi do
  let(:chinkin) { "/v2/merchants/checkin" }

  it "checkin" do
    mq100 = create :mq100
    res = auth_json_post chinkin, merchant_service_code: mq100.service_code, geolocation: "123,123"
    expect(CheckinHistory.count).to eq(1)

    ch = CheckinHistory.first
    expect(res[:id]).to eq(ch.id)
    expect(res[:merchant]).to eq(mq100.merchant.name)
  end
end
