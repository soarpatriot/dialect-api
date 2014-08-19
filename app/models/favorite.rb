class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :information

  validates :user_id, uniqueness: {scope: :information_id}, unless: Proc.new { |instance| instance.information.is_coupon? }
  validate :coupon_count_check

  after_create :coupon_reduce

  def favorited
    !self.user_id.nil? and !self.information_id.nil?
  end

  private

  def coupon_count_check
    return unless information.is_coupon?
    errors.add :not_enough_coupon, "there is no enough coupon" if information.infoable.count <= 0
  end

  def coupon_reduce
    if information.is_coupon?
      count = information.infoable.count
      information.infoable.update count: (count - 1) 
    end
  end
end
