class Message < ActiveRecord::Base
  belongs_to :chat

  def is_unread?
   not self.read
  end
end
