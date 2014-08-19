class CouponGiveRequestEntity < Grape::Entity
  expose :source_user_id,         documentation: {required: true, type: "Integer"}
  expose :target_user_id,         documentation: {required: true, type: "Integer"}
  expose :target_user_nickname,   documentation: {required: true, type: "String"}
  expose :target_user_avatar_url, documentation: {required: true, type: "String"}
  expose :coupon_id,              documentation: {required: true, type: "Integer"}
  expose :status,                 documentation: {required: true, type: "Integer"}
end
