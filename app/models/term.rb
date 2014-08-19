class Term < ActiveRecord::Base
  has_many :coupon_terms, dependent: :destroy
  has_many :coupons, through: :coupon_terms
end
