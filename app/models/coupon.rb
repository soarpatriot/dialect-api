class Coupon < ActiveRecord::Base
  # attrs: amount, expire_at, merchant_id, :user_id

  enum status: [:usable, :used, :expired]



  has_one :information, as: :infoable, dependent: :destroy

  belongs_to :owner, class_name: "Merchant", foreign_key: "merchant_id"
  has_many :coupon_terms, dependent: :destroy
  has_many :terms, through: :coupon_terms
  has_many :coupon_usage_histories, dependent: :destroy
  has_many :users, through: :coupon_usage_histories

  delegate :favorites, to: :information

  after_create :create_information

  alias_attribute :content, :title

  scope :available, -> { where("count > 0 and expire_at > ?", DateTime.now) }

  def self.random_record_for user, merchant
    offset = Kernel.rand Coupon.available.count
    Coupon.available.offset(offset).first
  end

  def summary
    self.title
  end

  private

  def create_information
    Information.create infoable: self
  end

end
