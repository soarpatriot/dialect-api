require 'spec_helper'

RSpec.describe Coupon, :type => :model do

  it "available" do
    create :coupon, count: 0
    create :coupon, expire_at: DateTime.now - 1.days
    coupon = create :coupon

    expect(Coupon.available.count).to eq(1)
    expect(Coupon.available.first).to eq(coupon)
  end

end
