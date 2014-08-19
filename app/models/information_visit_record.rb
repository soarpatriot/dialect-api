class InformationVisitRecord < ActiveRecord::Base
  belongs_to :information
  belongs_to :user

  validates :user_id, :information_id, presence: true
end
