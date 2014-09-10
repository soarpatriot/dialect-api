class VersionEntity < Grape::Entity

  expose :id,   documentation: {required: true, type: "Integer", desc: "id"}
  expose :url,   documentation: {required: true, type: "String", desc: "下载地址"}
  expose :platform,   documentation: {required: true, type: "String", desc: "系统平台 ios android"}
  expose :code,   documentation: {required: true, type: "Integer", desc: "版本代码"}
  expose :mandatory,   documentation: {required: true, type: "Boolean", desc: "是否强制更新"}
  expose :message,   documentation: {required: true, type: "String", desc: "是否强制更新"}
end
