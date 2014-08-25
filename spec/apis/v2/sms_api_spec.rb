require "spec_helper"

describe V1::SmsApi do

  let(:register_path) { "/v2/sms/send_register_code" }
  let(:reset_password_path) { "/v2/sms/send_reset_password_code" }

  it "fails without mobile_number" do
    res = json_post register_path
    expect(last_response.status).to eq(400)
    expect(res[:error]).to eq("mobile_number is missing")
  end

  it "send register code to exsited mobile_number" do
    create :user, mobile_number: "13800000000"
    res = json_post register_path, mobile_number: "13800000000"
    expect(Captcha.count).to eq(0)
    expect(res[:error]).to eq(I18n.t "user_exsisted")
  end

  it "send register code to non exsited mobile_number" do
    stub_request(:post, "http://115.28.23.78/api/send/")
    res = json_post register_path, mobile_number: "13800000000"
    expect(Captcha.count).to eq(1)
    expect(res[:code]).to eq(Captcha.first.code)
    expect(res[:mobile_number]).to eq(Captcha.first.mobile_number)
    expect(res[:type]).to eq("register")
  end

  it "send reset_password code to non exsited mobile_number" do
    res = json_post reset_password_path, mobile_number: "13800000000"
    expect(Captcha.count).to eq(0)
    expect(res[:error]).to eq(I18n.t("no_user_with_this_mobile_number"))
  end

  it "send reset_password code" do
    stub_request(:post, "http://115.28.23.78/api/send/")
    create :user, mobile_number: "13800000000"
    res = json_post reset_password_path, mobile_number: "13800000000"
    expect(Captcha.count).to eq(1)
    expect(res[:code]).to eq(Captcha.first.code)
    expect(res[:mobile_number]).to eq(Captcha.first.mobile_number)
    expect(res[:type]).to eq("reset_password")
  end

end
