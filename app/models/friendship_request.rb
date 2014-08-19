class FriendshipRequest < ActiveRecord::Base
  enum status: [:waiting, :done, :cancel]
  belongs_to :target_user, class_name: "User"
end
