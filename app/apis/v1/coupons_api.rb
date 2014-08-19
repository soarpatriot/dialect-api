class V1::CouponsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :coupons do

    desc "使用优惠券", {
      entity: CouponEntity
    }
    params do
      requires :id, type: Integer, desc: "coupon id"
      requires :service_code, type: String, desc: "mq100IIN service code"
    end
    post ":id/use" do
      mq100 = Mq100.iins.where(service_code: params[:service_code]).first
      locale_error! "wrong_service_code_to_find_mq100", 404 if mq100.nil?

      info = Information.find params[:id]
      locale_error! "could_not_find_coupon", 404 unless info.is_coupon? and !info.infoable.nil?

      coupon = info.infoable

      locale_error! "invalid_mq100", 400 unless coupon.owner == mq100.merchant or coupon.owner == mq100.merchant.try(:parent)
      # ! coupon already used checking
      # coupon_favorites_count = current_user.favorites.joins(:information).where("information.infoable_type = 'Coupon'").count
      # coupon_usage_histories_count = current_user.coupon_usage_histories.count

      # if coupon_favorites_count == coupon_usage_histories_count
      #   error! "coupon already used", 400
      # end
      locale_error! "coupon_expired", 400 if coupon.expire_at < DateTime.now

      favorite = Favorite.where(information_id: info.id, user_id: current_user.id).first
      if favorite
        coupon_usage_history = current_user.coupon_usage_histories.create coupon: coupon, status: "used"
        favorite.destroy
        present coupon_usage_history, with: CouponUsageHistoryEntity
      else
        local_error! "could_not_find_coupon", 404
      end
    end

  end

end
