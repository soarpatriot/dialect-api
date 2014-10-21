class Post < ActiveRecord::Base

  mount_uploader :image, PostImageUploader
  mount_uploader :sound, PostSoundUploader

end
