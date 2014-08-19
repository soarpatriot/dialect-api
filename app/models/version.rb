class Version < ActiveRecord::Base
  default_scope {order "id desc"}
  validates :code, :platform,:url, presence: true
end
