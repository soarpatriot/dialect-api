=begin
require "spec_helper"

describe V2::CouponsApi do

  def use_path information
    "/v2/coupons/#{information.id}/use"
  end

  context "use" do
    it "valid coupon id" do
      coupon = create :coupon
      mq100 = create :mq100, merchant: coupon.owner, model: "II_N"
      current_user.favorites.create information: coupon.information
      res = auth_json_post use_path(coupon.information), service_code: mq100.service_code
      expect(res[:status]).to eq("used")
    end

    it "valid coupon id and with a brand" do
      coupon = create :coupon
      merchant = create :merchant, parent_id: coupon.owner.id
      mq100 = create :mq100, merchant: merchant, model: "II_N"
      current_user.favorites.create information: coupon.information
      res = auth_json_post use_path(coupon.information), service_code: mq100.service_code
      expect(res[:status]).to eq("used")
    end

    it "invalid coupon id" do
      coupon = create :coupon
      mq100 = create :mq100, merchant: coupon.owner, model: "II_N"
      information = create :information
      res = auth_json_post use_path(information), service_code: mq100.service_code
      expect(res[:error]).to eq(I18n.t("could_not_find_coupon"))
    end

    it "invalid mq100" do
      coupon = create :coupon
      mq100 = create :mq100, model: "II_N"
      information = create :information, infoable: coupon
      res = auth_json_post use_path(information), service_code: mq100.service_code
      expect(res[:error]).to eq(I18n.t("invalid_mq100"))
    end



    it "already used" do
      coupon = create :coupon
      mq100 = create :mq100, merchant: coupon.owner, model: "II_N"
      current_user.favorites.create information: coupon.information
      current_user.coupon_usage_histories.create coupon: coupon
      res = auth_json_post use_path(coupon.information), service_code: mq100.service_code
      expect(res[:error]).to eq("coupon already used")
    end



    it "exipred" do
      coupon = create :coupon, expire_at: DateTime.now - 1.days
      mq100 = create :mq100, merchant: coupon.owner, model: "II_N"
      current_user.favorites.create information: coupon.information
      res = auth_json_post use_path(coupon.information), service_code: mq100.service_code
      expect(res[:error]).to eq(I18n.t "coupon_expired")
    end
  end


end
=end
