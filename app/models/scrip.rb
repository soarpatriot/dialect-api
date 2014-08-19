class Scrip < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord
  # attrs: content image user_id address longitude latitude
  include SoftDelete

  default_scope {order("id desc")}

  mount_uploader :image, ScripImageUploader
  reverse_geocoded_by :latitude, :longitude

  has_one :information, as: :infoable, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :owner, polymorphic: true


  scope :not_visited_of, ->(user) {
    self.unscoped.joins(:information)
      .joins("left outer join information_visit_records as t on t.information_id = information.id and t.user_id = #{user.id}")
      .where("t.information_id is null")
  }

  scope :order_by_hot, -> {
    self.unscoped.joins(:information)
      .order("information.comments_count desc")
      .order("information.votes_count desc")
      .order("information.shares_count desc")
      .order("information.visits_count desc")
  }

  after_create :create_information, :set_username, :set_random_image
  after_update :delete_comments_if_soft_delete
  after_validation :reverse_geocode, address: :address,  if: ->(obj) {
    (obj.latitude? and obj.longitude?) and (obj.latitude_changed? or obj.longitude_changed?) and obj.address.blank?
  }

  delegate :favorites, to: :information

  def self.random_record_for user, merchant, geolocation
    scrips = Scrip.order_by_hot.not_visited_of user
    # .where("owner_id <> ? and owner_type = 'User'", user.id)
    neared_scrips = scrips.near geolocation.split(",").map(&:to_f).reverse, Settings.geolocation.near_distance, units: :km unless geolocation.nil?

    unless neared_scrips.nil? or neared_scrips.count(:all) == 0
      offset = Kernel.rand neared_scrips.count(:all)
      neared_scrips.offset(offset).first
    else
      Scrip.not_visited_of(user).order("id desc").first
    end
  end

  def self.random_record
    Scrip.offset(Kernel.rand(Scrip.count)).first
  end

  def belongs_to_user?
    self.owner_type == "User"
  end

  def belongs_to_merchant?
    self.owner_type == "Merchant"
  end

  def summary
    self.belongs_to_merchant? ? self.title : self.content
  end

  def union_address

    address_arr =%W(#{self.country} #{self.province} #{self.city} #{self.district} #{self.street})
    address_arr.delete_if{|address| address.blank? }

    address_arr.compact!
    address_arr.uniq!
    address_arr.join(",")
  end

  private

  def create_information
    Information.create infoable: self
  end

  def set_username
    self.update username: self.owner.name
  end

  def set_random_image
    if self.image_url.nil? and !self.belongs_to_merchant?
      day_or_night = (6..18).include?(Time.now.hour) ? "day" : "night"
      random_index = rand(4) + 1
      image_uri = "#{G2.config.root_dir}/app/assets/images/scrips/#{day_or_night}#{random_index}.jpg"
      self.update image: File.open(image_uri)
    end
  end

  def delete_comments_if_soft_delete
    if self.is_destroyed?
      self.comments.delete_all
    end
  end

  def place
    self.information.try(:place)
  end

  def subject
    self.information.try(:subject)
  end

end
