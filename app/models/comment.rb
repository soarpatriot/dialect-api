class Comment < ActiveRecord::Base

  default_scope { order("id desc") }
  belongs_to :place
  belongs_to :user
  belongs_to :scrip

  after_create :increase_information_comments_count
  before_destroy :decrease_information_comments_count

  def increase_information_comments_count
    self.scrip.information.increase_for :comments_count
  end

  def decrease_information_comments_count
    self.scrip.information.decrease_for :comments_count if self.scrip.information and self.scrip.information.persisted?
  end
end
