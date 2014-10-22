class Post < ActiveRecord::Base

  has_many :comments
  mount_uploader :image, PostImageUploader
  mount_uploader :sound, PostSoundUploader

end
