class CouponUsageHistory < ActiveRecord::Base
  enum status: [:usable, :used, :expired]

  belongs_to :coupon
  belongs_to :user

  validate :coupon_favorited_by_user

  private

  def coupon_favorited_by_user
    if coupon.favorites.where(user_id: user.id).first.nil?
      errors.add(:invalid_coupon, "couldn't find coupon with coupon_id #{coupon.id} and user_id #{user.id}")
    end
  end
end
