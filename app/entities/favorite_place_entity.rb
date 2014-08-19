class FavoritePlaceEntity < Grape::Entity
  expose :favorite_id, documentation: {required: true, type: "Integer", desc: "收藏ID"} do |instance, options|
    instance.id
  end
  expose :place_id,   documentation: {required: true, type: "Integer", desc: "地点ID"}
  expose :name, documentation: {required: true, type: "String", desc:"地点名称"}
  expose :image_url,   documentation: {required: true, type: "String", desc: "地点图片"}
  expose :address,   documentation: {required: true, type: "String", desc: "地点地址"}
  expose :created_at,  documentation: {required: true, type: "String", desc: "地点创建时间"}
end
