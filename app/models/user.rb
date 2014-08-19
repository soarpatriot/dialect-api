class User < ActiveRecord::Base
  has_secure_password

  enum gender: [:other, :male, :female]
  enum group: [:normal, :market]

  acts_as_voter


  validates :nickname, :mobile_number, :password_digest, presence:true
  validates :nickname, :mobile_number, uniqueness: true
  validates :password, length: { minimum: 8 }, if: :password

  has_one  :soundink_code
  has_many :auth_tokens, dependent: :destroy
  has_many :scrips, as: :owner, dependent: :destroy
  has_many :checkin_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :friendship_requests, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :coupon_usage_histories, dependent: :destroy
  has_many :coupons, through: :coupon_usage_histories
  has_many :information_visit_records, dependent: :destroy
  has_many :information_share_records, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :feedbacks,dependent: :destroy
  has_many :chats, as: :owner, dependent: :destroy
  has_many :favorite_places, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :place_user_relations, dependent: :destroy
  has_many :places, through: :place_user_relations

  delegate :service_code, to: :soundink_code, allow_nil: true

  before_validation :allocate_soundink_code
  after_create :set_random_avatar

  alias_attribute :name, :nickname

  def self.non_login
    where(nickname: "non_login").first
  end

  def is_non_login?
    self.nickname == "non_login"
  end

  def authenticate_by_token token_value
    if self.auth_tokens.where(value: token_value).first
      self
    else
      false
    end
  end

  def avatar_url
    "fix me"
=begin
    unless self.nil? and self.avatar.nil?
      if not self.avatar.try(:thumb).url.nil?
        self.avatar.url(:thumb)
      else
        self.avatar.url
      end
    end
=end
  end

  private

  def allocate_soundink_code
    return unless self.soundink_code.nil?
    soundink_code = SoundinkCode.first
    if soundink_code.nil?
      errors.add :service_code, "there is no available service code to allocate to user" 
    else
      self.soundink_code = soundink_code
    end
  end

  def set_random_avatar

    self.update avatar: File.open("#{G2.config.root_dir}/app/assets/images/avatars/#{(rand(10) + 1)}.jpg")

    # self.update avatar: File.open("#{Rails.root.join('app/assets/images/avatars/')}#{(rand(10) + 1)}.jpg")
  end


end
