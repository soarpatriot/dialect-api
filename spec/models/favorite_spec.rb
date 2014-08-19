require 'rails_helper'

RSpec.describe Favorite, :type => :model do
  
  before(:each) do
    stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
  end

  it "not enough coupon" do
    coupon = create :coupon, count: 0
    favorite = build :favorite, information: coupon.information
    expect(favorite).not_to be_valid
    expect(favorite.errors[:not_enough_coupon]).to eq(["there is no enough coupon"])
  end

  it "favorite multi same coupon" do
    coupon = create :coupon
    user = create :user
    favorite = create :favorite, information: coupon.information, user: user
    expect(favorite.errors.size).to eq(0)

    favorite2 = create :favorite, information: coupon.information, user: user
    expect(favorite2.errors.size).to eq(0)

    expect(Favorite.count).to eq(2)
  end

  it "can't favorite multi same scrip" do
    scrip = create :scrip
    user = create :user
    favorite = create :favorite, information: scrip.information, user: user
    expect(favorite.errors.size).to eq(0)

    favorite2 = build :favorite, information: scrip.information, user: user
    expect(favorite2).not_to be_valid

    expect(Favorite.count).to eq(1)
  end
end
