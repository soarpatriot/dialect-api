class CommentInformationEntity < Grape::Entity
  include ActionView::Helpers::DateHelper

  expose :id,   documentation: {required: true, type: "Integer", desc: "id"} do |instance, options|
    instance.scrip.information.id
  end
  expose :comment_id, documentation: {required: true, type: "Integer"} do |instance, options|
    instance.id
  end
  expose :user_id,        documentation: {required: true, type: "Integer"} do |instance, options|
    instance.user_id
  end
  expose :scrip_id,        documentation: {required: true, type: "Integer"} do |instance, options|
    instance.scrip_id
  end
  expose :place_id,        documentation: {required: true, type: "Integer"} do |instance, options|
    instance.place_id
  end
  expose :content,        documentation: {required: true, type: "Integer"} do |instance, options|
    instance.content
  end
  expose :address,        documentation: {required: true, type: "Integer"} do |instance, options|
    instance.address
  end
  expose :type, documentation: {required: true, type: "String", desc: "类型"} do |instance, options|
    "Scrip"
  end
  expose :image_url, documentation: {required: true, type: "String", desc: "图片地址"} do |instance, options|
    instance.scrip.try(:image_url)
  end
  expose :thumb_image_url, documentation: {required: true, type: "String", desc: "缩略图片地址"} do |instance, options|
      instance.scrip.try(:image).try(:url, :thumb)
  end
  expose :url,  documentation: {required: true, type: "String", desc: "URL地址"} do |instance, options|
    instance.scrip.information.url + "?auth_token=#{options[:auth_token]}&locale=#{I18n.locale}"
  end
  expose :share_title,  documentation: {required: true, type: "String", desc: "供分享使用的title"} do |instance, options|
    Settings.share_title
  end
  expose :share_url,  documentation: {required: true, type: "String", desc: "供分享使用的URL地址"} do |instance, options|
    instance.scrip.information.share_url + "?locale=#{I18n.locale}"
  end
  expose :owner_id,  documentation: {required: true, type: "String", desc: "owner id"} do |instance, options|
    instance.scrip.try(:owner).try(:id)
  end
  expose :owner_nickname,  documentation: {required: true, type: "String", desc: "用户昵称"} do |instance, options|
    instance.scrip.try(:owner).try(:name)
  end
  expose :owner_avatar_url,  documentation: {required: true, type: "String", desc: "用户头像URL地址"} do |instance, options|
    instance.scrip.try(:owner).try(:avatar_url)
  end
  expose :address,  documentation: {required: true, type: "String", desc: ""} do |instance, options|
    instance.scrip.try(:address)
  end
  expose :summary,  documentation: {required: true, type: "String", desc: "简述"} do |instance, options|
    instance.scrip.try(:summary)
  end
  expose :created_at,  documentation: {required: true, type: "String", desc: "发布时间"} do |instance, options|
    time_ago_in_words instance.created_at
  end
  expose :comments_count,  documentation: {required: true, type: "Integer", desc: "评论数量"} do |instance, options|
    instance.scrip.information.comments_count
  end
  expose :votes_count,  documentation: {required: true, type: "Integer", desc: "赞数量"} do |instance, options|
    instance.scrip.information.votes_count
  end
  expose :visits_count,  documentation: {required: true, type: "Integer", desc: "浏览数量"} do |instance, options|
    instance.scrip.information.visits_count
  end
  expose :shares_count,  documentation: {required: true, type: "Integer", desc: "分享数量"} do |instance, options|
    instance.scrip.information.shares_count
  end
end
