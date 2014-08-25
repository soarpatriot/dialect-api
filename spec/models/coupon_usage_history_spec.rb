require 'spec_helper'

RSpec.describe CouponUsageHistory, :type => :model do
  it "multi same coupon user history" do
    coupon = create :coupon
    user = create :user
    favorite1 = create :favorite, information: coupon.information, user: user
    favorite2 = create :favorite, information: coupon.information, user: user

    create :coupon_usage_history, coupon: coupon, user: favorite1.user
    create :coupon_usage_history, coupon: coupon, user: favorite2.user

    expect(CouponUsageHistory.count).to eq(2)
  end

  it "must be favirited" do
    cuh = build :coupon_usage_history
    expect(cuh).not_to be_valid
    expect(cuh.errors[:invalid_coupon]).to eq(["couldn't find coupon with coupon_id #{cuh.coupon_id} and user_id #{cuh.user_id}"])
  end
end
