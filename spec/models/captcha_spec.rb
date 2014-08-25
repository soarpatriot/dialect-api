require 'spec_helper'

RSpec.describe Captcha, :type => :model do

  it "random number" do
    captcha = create :captcha
    expect(captcha.code.to_i).to be>0
    expect(captcha.code.to_i).to be<10000
  end

end
