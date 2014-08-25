class Captcha < ActiveRecord::Base
  enum ctype: [:register, :reset_password]

  before_create :set_code

  private

  def set_code
    self.code = SecureRandom.random_number(10000).to_s
  end
end
