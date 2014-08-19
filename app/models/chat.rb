class Chat < ActiveRecord::Base

  enum ctype: [:chat, :system, :information]

  belongs_to :last_sender, polymorphic: true
  belongs_to :owner, polymorphic: true
  belongs_to :target, polymorphic: true

  def information
    Information.find self.information_id
  end

end
