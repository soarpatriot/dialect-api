class CaptchaEntity < Grape::Entity
  expose :mobile_number,    documentation: {required: true, type: "String", desc: "手机号"}
  expose :code,    documentation: {required: true, type: "String", desc: "验证码"}
  expose :created_at, documentation: {required: true, type: "Integer", desc: "验证码发送时间"}
  expose :type, documentation: {required: true, type: "Integer", desc: "类型"} do |instance, options|
    instance.ctype
  end
end
