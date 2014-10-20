require "spec_helper"

describe V1::UserApi do

  let(:login_path) { "/v1/user/login" }
  let(:register_path) { "/v1/user/register" }

  def user_scrips_path user
    "/v2/user/#{user.id}/scrips"
  end
  context "register" do
    it "fails without mobile_number or password or register_code or nickname" do
      res = json_post register_path
      expect(res[:error]).to eq("name is missing, password is missing")
    end

    it "succes" do
      res = json_post register_path, name:"aaa", password:"bbb"

    end

  end

  context "login" do

  end



end
