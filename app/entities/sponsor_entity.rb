class SponsorEntity < Grape::Entity
  expose :id,    documentation: {required: true, type: "Integer", desc: "赞助商id"}
  expose :title, documentation: {required: true, type: "String", desc: "赞助商名称"}
  expose :information_id, documentation: {required: true, type: "Integer", desc: "赞助商纸条信息ID"} do |instance, options|
    instance.scrip.information.id
  end
  expose :logo_url, documentation: {required: true, type: "String", desc: "赞助商LOGO URL"}
  expose :url,   documentation: {required: true, type: "String", desc: "赞助商纸条详情页面的URL"} do |instance, options|
    instance.scrip.information.url + "?auth_token=#{options[:auth_token]}&locale=#{I18n.locale}"
  end
  expose :always_show, documentation: {required: true, type: "Boolean", desc: "是否一直显示提示"}
end
