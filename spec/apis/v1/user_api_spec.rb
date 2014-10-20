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
      expect(res[:name]).to eq("aaa")
    end

  end

  context "login" do
    it "fail" do
      user = create :user
      res = json_post login_path, name:user.name, password:121
      binding.pry
      expect(res[:name]).to eq(user.name)
    end
    it "success" do
      user = create :user
      res = json_post login_path, name:user.name, password:user.password

      expect(res[:name]).to eq(user.name)
    end
  end



end
