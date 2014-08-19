class UserEntity < Grape::Entity
  expose :id,            documentation: {required: true, type: "Integer", desc: "user id"}
  expose :nickname,      documentation: {required: true, type: "String"} do |instance, options|
    instance.nickname.try(:force_encoding, "UTF-8")
  end
  expose :gender,        documentation: {required: true, type: "String"}
  expose :avatar_url,    documentation: {required: true, type: "String"}
  expose :auth_token,    documentation: {required: true, type: "String"}, if: {return_token: true} do |instance, options|
    instance.auth_tokens.first.value
  end
  expose :service_code,  documentation: {required: true, type: "String"}
end
