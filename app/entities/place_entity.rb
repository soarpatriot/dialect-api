class PlaceEntity < Grape::Entity
  expose :favorited, documentation: {required: true, type: "Boolean"} do |instance, options|
    options[:user].favorite_places.where(place_id: instance.id).any?
  end
  expose :place_id,   documentation: {required: true, type: "Integer", desc: "id"} do |instance, options|
    instance.id
  end
  expose :name, documentation: {required: true, type: "String", desc:"地点名称"}
  expose :address
  expose :image_url,   documentation: {required: true, type: "String", desc: "地点图片"}
  expose :created_at,  documentation: {required: true, type: "String", desc: "地点创建时间"}
end
