class SubjectEntity < Grape::Entity
  expose :id,          documentation: {required: true, type: "Integer", desc: "id"}
  expose :name,        documentation: {required: true, type: "String", desc: "专题名称"}
  expose :image_url,   documentation: {required: true, type: "String", desc: "专题图片"}
  expose :created_at,  documentation: {required: true, type: "String", desc: "专题创建时间"}
end
