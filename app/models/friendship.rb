class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: "User"

  after_create :set_inverse_friendship, if: :no_inverse_friendship_found

  private

  def no_inverse_friendship_found
    !self.class.exists?(user_id: self.friend_id, friend_id: self.user_id)
  end

  def set_inverse_friendship
    self.class.create! user_id: self.friend_id, friend_id: self.user_id
  end
end
