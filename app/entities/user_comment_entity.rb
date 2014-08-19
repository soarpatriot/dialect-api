class UserCommentEntity < Grape::Entity
  expose :id,            documentation: {required: true, type: "Integer", desc: "user id"} do |instance, options|
    instance.user.id
  end
  expose :nickname,      documentation: {required: true, type: "String"} do |instance, options|
    instance.user.nickname.try(:force_encoding, "UTF-8")
  end
  expose :gender,        documentation: {required: true, type: "String"} do |instance, options|
    instance.user.gender
  end
  expose :avatar_url,    documentation: {required: true, type: "String"} do |instance, options|
    instance.user.avatar_url
  end
  expose :auth_token,    documentation: {required: true, type: "String"}, if: {return_token: true} do |instance, options|
    instance.user.auth_tokens.first.value
  end
  expose :service_code,  documentation: {required: true, type: "String"} do |instance, options|
    instance.user.service_code
  end
  expose :created_at, documentation: {required: true, type: "String", desc: "用户评论的时间"} do |instance, options|
    instance.created_at.localtime.to_formatted_s(:db)
  end
end
