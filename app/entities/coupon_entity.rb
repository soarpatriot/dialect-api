class CouponEntity < Grape::Entity
  expose :id, documentation: {required: true, type: "Integer", desc: "coupon id"}
  expose :url, documentation: {required: true, type: "String", desc: "coupon web page url"} do |instance, options|
    instance.information.url
  end
  expose :status, documentation: {required: true, type: "String", desc: "coupon status, [usable|used|expired]"}
end
