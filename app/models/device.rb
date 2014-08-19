class Device < ActiveRecord::Base

  enum status: [:active, :inactive]

  belongs_to :user
end
