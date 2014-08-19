class Mq100 < ActiveRecord::Base

  II_L = "II_L"
  II_N = "II_N"

  belongs_to :merchant

  scope :iins, -> { where(model: II_N) }

  def self.available_mq100ns
    mq100ls = self.where(model:self::II_N, merchant_id: nil)
  end
  def self.available_mq100ls
    mq100ls = self.where(model:self::II_L, merchant_id: nil)
  end
end
