class FavoritePlace < ActiveRecord::Base

  belongs_to :place
  belongs_to :user

  delegate :name, to: :place, allow_nil: true
  delegate :image_url, to: :place, allow_nil: true
  delegate :address, to: :place, allow_nil: true
end
