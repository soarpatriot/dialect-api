require "rails_helper"

describe V2::UserApi do

  let(:login_path) { "/v2/user/login" }
  let(:register_path) { "/v2/user/register" }
  let(:reset_password_path) { "/v2/user/reset_password" }
  let(:change_password_path) { "/v2/user/change_password" }
  let(:update_profile_path) { "/v2/user/update_profile" }
  let(:user_scrips_commented_path) { "/v2/user/scrips/commented" }
  let(:user_scrips_favorited_path) { "/v2/user/scrips/favorited" }

  def user_scrips_path user
    "/v2/user/#{user.id}/scrips"
  end
  context "register" do
    it "fails without mobile_number or password or register_code or nickname" do
      res = json_post register_path
      expect(res[:error]).to eq("country_code is missing, mobile_number is missing, register_code is missing, nickname is missing, password is missing")
    end

    it "fails | no available soundink code" do
      expect(SoundinkCode.count).to eq(0)
      mobile_number = "+8613800000000"
      captcha = Captcha.create mobile_number: mobile_number, ctype: "register"
      res = json_post register_path, country_code: 86, mobile_number: mobile_number, register_code: captcha.code, nickname: "nickanme", password: "secret09"
      expect(res[:error]).to eq("Service code there is no available service code to allocate to user")
    end

    it "fails | wrong register code" do
      expect(SoundinkCode.count).to eq(0)
      mobile_number = "+8613800000000"
      captcha = Captcha.create mobile_number: mobile_number, ctype: "register"
      res = json_post register_path, country_code: 86, mobile_number: mobile_number, register_code: "wrong code", nickname: "nickanme", password: "secret09"
      expect(res[:error]).to eq(I18n.t("wrong_register_code"))
    end

    it "success with correct params" do
      create :soundink_code
      mobile_number = "+8613800000000"
      captcha = Captcha.create mobile_number: mobile_number, ctype: "register"
      json_post register_path, country_code: 86, mobile_number: mobile_number, register_code: captcha.code, nickname: "nickanme", password: "secret09"
      expect(User.count).to eq(1)
      expect(mobile_number).to eq(User.first.mobile_number)
    end
  end

  context "login" do
    it "fails whithout mobile_number or password" do
      res = json_post login_path

      # need bo be fixed.. according to the i18n
      expect(res[:error]).to eq("mobile_number is missing, password is missing")

    end

    it "fails with wrong mobile_number or password" do
      user = create :user, mobile_number: "13800000000", password: "secret09"
      res = json_post login_path, {mobile_number: "13811111111", password: "secret10"}
      expect(last_response.status).to eq(401)
      expect(res[:error]).to eq(I18n.t("invalid_mobile_number_or_password"))

      res = json_post login_path, {mobile_number: user.mobile_number, password: "secret10"}
      expect(last_response.status).to eq(401)
      expect(res[:error]).to eq(I18n.t("invalid_mobile_number_or_password"))
    end

    it "success with right mobile_number and password" do
      user = create :user, country_code: 86, mobile_number: "+8613800000000", password: "secret09"
      res = json_post login_path, {mobile_number: user.mobile_number, password: "secret09"}
      expect(last_response.status).to eq(201)
      expect(res[:id]).to eq(user.id)
    end
  end

  context "reset password" do
    it "reset password without right reset password code" do
      user = create :user, mobile_number: "13800000000"
      res = json_post reset_password_path, {mobile_number: user.mobile_number, reset_password_code: "123", password: "secret10"}
      expect(res[:error]).to eq(I18n.t("wrong_register_code"))
    end

    it "reset password with right reset password code" do
      user = create :user, mobile_number: "13800000000"
      captcha = Captcha.create mobile_number: user.mobile_number, ctype: "reset_password"
      json_post reset_password_path, {mobile_number: user.mobile_number, reset_password_code: captcha.code, password: "secret10"}
      user.reload
      expect(user.authenticate("secret10")).to eq(user)
    end
  end

  context "change password" do
    it "change password with wrong params" do
      user = create :user, mobile_number: "13800000000", password: "secret09"
      token = user.auth_tokens.create
      res = json_post change_password_path, current_password: "secret08", new_password: "secret10", auth_token: token.value
      expect(res[:error]).to eq(I18n.t("wrong_current_password"))
    end

    it "change password with correct params" do
      user = create :user, mobile_number: "13800000000", password: "secret09"
      token = user.auth_tokens.create
      json_post change_password_path, current_password: "secret09", new_password: "secret10", auth_token: token.value
      user.reload
      res = user.authenticate "secret10"
      expect(res[:id]).to eq(user.id)
    end
  end

  context "update profile" do
    it "update profile with valid params" do
      user = create :user
      token = user.auth_tokens.create
      res = json_post update_profile_path, nickname: "new nickname", auth_token: token.value
      user.reload
      expect(res[:nickname]).to eq("new nickname")
      expect(user.nickname).to eq("new nickname")
    end
  end



  context "users favorited" do

    it "no before,one favorited" do
      scrip1 =  create(:scrip, owner: create(:user))
      information1 = create :information, infoable: scrip1
      favorite1 = create(:favorite, information: information1, user: current_user )
      res = auth_json_get user_scrips_favorited_path
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end

    it "no before,many favorited" do
      Settings.paginate_per_page*3.times do
        scrip =  create(:scrip, owner: create(:user))
        information = create :information, infoable: scrip
        favorite = create(:favorite, information: information, user: current_user )
      end
      res = auth_json_get user_scrips_favorited_path
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "only one favorited with before" do
      scrip1 =  create(:scrip, owner: create(:user))
      information1 = create :information, infoable: scrip1
      favorite1 = create(:favorite, information: information1, user: current_user )

      res = auth_json_get user_scrips_favorited_path, before: favorite1.id
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "before favorited" do
      Settings.paginate_per_page*3.times do
        scrip =  create(:scrip, owner: create(:user))
        information = create :information, infoable: scrip
        favorite = create(:favorite, information: information, user: current_user )
      end
      scrip1 =  create(:scrip, owner: create(:user))
      information1 = create :information, infoable: scrip1
      favorite1 = create(:favorite, information: information1, user: current_user )

      res = auth_json_get user_scrips_favorited_path, before: favorite1.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end
  end

  context "users commented scrip" do
    it "no before,one commented" do
      scrip1 =  create(:scrip, owner: create(:user))
      create(:comment, scrip: scrip1, user: current_user )
      res = auth_json_get user_scrips_commented_path
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end

    it "no before,many commented" do
      Settings.paginate_per_page*3.times do
        scrip1 =  create(:scrip, owner: create(:user))
        create(:comment, scrip: scrip1, user: current_user )
      end
      res = auth_json_get user_scrips_commented_path
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "only one commented with before" do
      scrip1 =  create(:scrip, owner: create(:user))
      comment = create(:comment, scrip: scrip1, user: current_user )
      res = auth_json_get user_scrips_commented_path, before: scrip1.information.id
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "two commented,duplicated,only show one  " do
      scrip1 =  create(:scrip, owner: create(:user))
      comment = create(:comment, scrip: scrip1, user: current_user )
      comment1 = create(:comment, scrip: scrip1, user: current_user )
      res = auth_json_get user_scrips_commented_path
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end

    it "before commented" do 
      Settings.paginate_per_page*3.times do
        scrip =  create(:scrip, owner: create(:user))
        create(:comment, scrip: scrip, user: current_user )
      end
      scrip1 =  create(:scrip, owner: create(:user))
      comment = create(:comment, scrip: scrip1, user: current_user )
      res = auth_json_get user_scrips_commented_path,before: scrip1.information.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(2)
    end


  end

  context "user's scrip" do

    it "no before,one scrip" do
      scrip1 =  create(:scrip, owner: current_user)
      res = auth_json_get user_scrips_path(current_user), id: current_user.id
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end

    it "no before,many scrips" do
      create_list(:scrip,Settings.paginate_per_page*3, owner: current_user)
      res = auth_json_get user_scrips_path(current_user), id: current_user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "only one scrips with before" do
      scrip1 =  create(:scrip, owner: current_user)
      res = auth_json_get user_scrips_path(current_user), id: current_user.id, before: scrip1.information.id
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "before scrips" do
      create_list(:scrip,Settings.paginate_per_page*3, owner: current_user)
      scrip1 =  create(:scrip, owner: current_user)
      res = auth_json_get user_scrips_path(current_user), before: scrip1.information.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end
  end

end
