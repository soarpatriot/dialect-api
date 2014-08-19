class Place < ActiveRecord::Base



  has_many :information, dependent: :destroy
  has_many :place_user_relations, dependent: :destroy
  has_many :users, through: :place_user_relations
  belongs_to :user

  def address
    "#{self.province}#{self.city}#{self.district}#{self.street}#{self.street_number}"
  end

  def image_url
    "fix me"
  end
end
