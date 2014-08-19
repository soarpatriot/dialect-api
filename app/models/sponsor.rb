class Sponsor < ActiveRecord::Base
  mount_uploader :logo, SponsorLogoUploader

  validates :title, :start_at, :end_at, presence: true
  validate :check_scrip

  def scrip
    Scrip.find self.scrip_id
  end

  private

  def check_scrip
    scrip = Scrip.where id: self.scrip_id
    errors.add :invalid_scrip, "Couldn't find scrip by id #{self.scrip_id}" if scrip.nil?
  end
end
