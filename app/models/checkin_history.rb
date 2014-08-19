class CheckinHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :merchant
end
