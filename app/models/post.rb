class Post < ActiveRecord::Base

  belongs_to :user
  has_many :comments
  mount_uploader :image, PostImageUploader
  mount_uploader :sound, PostSoundUploader

end
