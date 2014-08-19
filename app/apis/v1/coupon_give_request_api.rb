class V1::CouponGiveRequestApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  namespace :coupon_give_request do

    desc "优惠券赠送状态", {
      entity: CouponGiveRequestEntity
    }
    get :status do
    end

    desc "取消优惠券赠送", {
      entity: CouponGiveRequestEntity
    }
    post :cancel do
    end

    desc "当面赠送优惠券（通过声印码）,并添加对方为好友", {
      entity: CouponGiveRequestEntity
    }
    params do
      requires :coupon_id, type: Integer, desc: "coupon id"
    end
    post "face_to_face" do
    end

    desc "线上赠送给朋友", {
      entity: CouponGiveRequestEntity
    }
    params do
      requires :coupon_id, type: Integer, desc: "coupon id"
      requires :friend_id, type: Integer, desc: "friend id"
    end
    post "online" do
    end

    desc "接受优惠券赠送", {
      entity: CouponGiveRequestEntity
    }
    params do
      requires :service_code, type: String, desc: "source user service code"
    end
    post "accept" do
    end

  end

end
