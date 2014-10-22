require "spec_helper"

describe V1::UserApi do

  let(:login_path) { "/v1/user/login" }
  let(:register_path) { "/v1/user/register" }


  context "register" do
    it "fails without mobile_number or password or register_code or nickname" do
      res = json_post register_path
      expect(res[:error]).to eq("name is missing, password is missing")
    end

    it "succes" do
      res = json_post register_path, name:"aaa", password:"bbb"
      expect(res[:code]).to eq(0)
    end

  end

  context "login" do
    it "fail" do
      user = create :user
      res = json_post login_path, name:user.name, password:121
      expect(res[:error]).to eq(I18n.t("invalid_mobile_number_or_password"))
    end
    it "success" do
      user = create :user
      res = json_post login_path, name:user.name, password:user.password
      expect(res[:name]).to eq(user.name)
    end
  end



end
