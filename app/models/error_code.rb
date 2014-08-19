class ErrorCode < ActiveRecord::Base

  def self.get code
    instance = ErrorCode.where(code: code).first
    if instance
      {
        code: instance.code,
        error: instance.summary
      }
    else
      {
        code: 500,
        error: "invalid error code"
      }
    end
  end

end
