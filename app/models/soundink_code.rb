class SoundinkCode < ActiveRecord::Base

  validates :service_code, uniqueness: true
  belongs_to :user
  scope :available, -> { where(user_id: nil) }

  def self.import_from_ssp
    res = RestClient.get "#{Settings.SSP_API_URL}?auth_token=#{Settings.SSP_AUTH_TOKEN}&code_type=SOFT&count=100"
    codes = JSON.parse res, symbolize_names: true
    codes.each do |code|
      self.where(service_code: code[:service_code]).first_or_create
    end
  end
end
