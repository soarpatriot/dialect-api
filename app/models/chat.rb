class Chat < ActiveRecord::Base

  enum ctype: [:chat, :system, :information]

  belongs_to :last_sender, polymorphic: true
  belongs_to :owner, polymorphic: true
  belongs_to :target, polymorphic: true
  has_many :messages, dependent: :destroy

  after_create :set_last_sync_at

  def information
    Information.find self.information_id
  end

  def self.create_for_information_favorite information, last_sender
    owner = information.try(:infoable).try(:owner)
    if owner and owner.is_a?(User)
      chat = owner.chats.where(information_id: information.id, ctype: Chat.ctypes[:information]).first_or_create
      chat.update last_sender: last_sender, last_message: I18n.t("chats.has_user_favorite_my_information", sender: last_sender.nickname)
    end
  end

  def self.create_for_information_comment information, last_sender, comment
    owner = information.try(:infoable).try(:owner)
    if owner and owner.is_a?(User)
      chat = owner.chats.where(information_id: information.id, ctype: Chat.ctypes[:information]).first_or_create
      chat.update last_sender: last_sender, last_message: I18n.t("chats.has_user_comment_my_information", sender: last_sender.nickname, comment: comment)
    end
  end

  private

  def set_last_sync_at
    self.update last_sync_at: DateTime.now
  end
end
