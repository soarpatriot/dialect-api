class CouponTerm < ActiveRecord::Base

  belongs_to :coupon
  belongs_to :term

end
