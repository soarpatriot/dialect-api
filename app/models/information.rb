class Information < ActiveRecord::Base
  include SoftDelete

  acts_as_votable

  belongs_to :infoable, polymorphic: true
  belongs_to :place

  has_many :favorites, dependent: :destroy
  has_many :information_visit_records, dependent: :destroy
  has_many :information_share_records, dependent: :destroy
  has_many :reports, dependent: :destroy

  after_update :soft_delete_scrip

  def self.get_recommended_record_for user, merchant, geolocation
    infoables = [:scrip, :coupon]

    random_index = 0
    random_index = Kernel.rand infoables.size if !merchant.nil?

    information = self.send "rand_#{infoables[random_index]}", user, merchant, geolocation
    information = rand_scrip user, merchant, geolocation if information.nil?

    information
  end

  def self.rand_scrip user, merchant, geolocation
    information = Scrip.random_record_for(user, merchant, geolocation).try(:information)
    information = Scrip.random_record.try(:information) if information.nil?
    information
  end

  def self.rand_coupon user, merchant, geolocation
    information = Coupon.random_record_for(user, merchant).try(:information)
    user.favorites.create information: information unless information.nil?
    information
  end

  def increase_for count_type
    self.update_column count_type, self.send(count_type) + 1
  end

  def decrease_for count_type
    self.update_column count_type, self.send(count_type) - 1 if self.send(count_type) > 0
  end

  def self.get_system_notice_scrip
    Scrip.where(title: "system_notice").first.information
  end

  def url
    Settings.host + "/information/#{self.id}"
  end

  def share_url
    Settings.host + "/information/#{self.id}/show2"
  end

  def is_coupon?
    self.infoable_type == "Coupon"
  end

  def is_scrip?
    self.infoable_type == "Scrip"
  end

  def is_subject?
    self.infoable_type == "Subject"
  end

  def is_coupon_taken?
    #! 不能返回已经识别过的优惠券
    self.is_coupon? and self.infoable.count <= 0
  end

  private

  def soft_delete_scrip
    if is_destroyed?
      self.infoable.soft_delete if self.is_scrip?
      self.favorites.destroy_all
    end
  end
end
