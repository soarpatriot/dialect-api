class Merchant < ActiveRecord::Base

  # acts_as_tree
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
=begin
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
=end



  alias_attribute :avatar_url, :logo_url
  has_many :coupons
  has_many :mq100s

  has_many :mq100ls,  -> {where(model: Mq100::II_L)}, :class_name => "Mq100"# conditions: ["device_type = ?", Mq100::II_L]
  has_many :mq100ns, -> {where(model: Mq100::II_N)}, :class_name => "Mq100"  # conditions: ["device_type = ?", Mq100::II_N]

  has_many :merchant_terms
  has_many :terms, through: :merchant_terms
  has_many :scrips, as: :owner

  def logo_url
    "fix me"
  end
end
