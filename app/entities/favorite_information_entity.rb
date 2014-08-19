class FavoriteInformationEntity < Grape::Entity
  include ActionView::Helpers::DateHelper

  expose :id,   documentation: {required: true, type: "Integer", desc: "id"} do |instance, options|
    instance.information_id
  end
  expose :favorite_id, documentation: {required: true, type: "Integer"} do |instance, options|
    instance.id
  end
  expose :user_id,        documentation: {required: true, type: "Integer"} do |instance, options|
    instance.user_id
  end
  expose :favorited,      documentation: {required: true, type: "String"}
  expose :type, documentation: {required: true, type: "String", desc: "类型"} do |instance, options|
    instance.information.infoable_type
  end
  expose :image_url, documentation: {required: true, type: "String", desc: "图片地址"} do |instance, options|
    instance.information.try(:infoable).try(:image_url)
  end
  expose :thumb_image_url, documentation: {required: true, type: "String", desc: "缩略图片地址"} do |instance, options|
    if instance.information.is_scrip?
      instance.information.try(:infoable).try(:image).try(:url, :thumb)
    else
      instance.information.try(:infoable).try(:image_url)
    end
  end
  expose :middle_image_url, documentation: {required: true, type: "String", desc: "中等尺寸图片地址"} do |instance, options|
    if instance.information.is_scrip?
      instance.information.try(:infoable).try(:image).try(:url, :show)
    else
      instance.information.try(:infoable).try(:image_url)
    end
  end
  expose :url,  documentation: {required: true, type: "String", desc: "URL地址"} do |instance, options|
    instance.information.url + "?auth_token=#{options[:auth_token]}&locale=#{I18n.locale}"
  end
  expose :share_title,  documentation: {required: true, type: "String", desc: "供分享使用的title"} do |instance, options|
    Settings.share_title
  end
  expose :share_url,  documentation: {required: true, type: "String", desc: "供分享使用的URL地址"} do |instance, options|
    instance.information.share_url + "?locale=#{I18n.locale}"
  end
  expose :owner_id,  documentation: {required: true, type: "String", desc: "owner id"} do |instance, options|
    instance.information.infoable.try(:owner).try(:id)
  end
  expose :owner_nickname,  documentation: {required: true, type: "String", desc: "用户昵称"} do |instance, options|
    instance.information.infoable.try(:owner).try(:name)
  end
  expose :owner_avatar_url,  documentation: {required: true, type: "String", desc: "用户头像URL地址"} do |instance, options|
    instance.information.infoable.try(:owner).try(:avatar_url)
  end
  expose :place,  documentation: {required: true, type: "String", desc: "地点"} do |instance, options|
    instance.information.place.try(:name)
  end
  expose :address,  documentation: {required: true, type: "String", desc: "地址"} do |instance, options|
    if instance.information.place
      instance.information.place.address
    else
      instance.information.infoable.try(:address)
    end
  end
  expose :summary,  documentation: {required: true, type: "String", desc: "简述"} do |instance, options|
    instance.information.infoable.try(:summary)
  end
  expose :created_at,  documentation: {required: true, type: "String", desc: "发布时间"} do |instance, options|
    time_ago_in_words instance.created_at
  end
  expose :comments_count,  documentation: {required: true, type: "Integer", desc: "评论数量"} do |instance, options|
    instance.information.comments_count
  end
  expose :votes_count,  documentation: {required: true, type: "Integer", desc: "赞数量"} do |instance, options|
    instance.information.votes_count
  end
  expose :visits_count,  documentation: {required: true, type: "Integer", desc: "浏览数量"} do |instance, options|
    instance.information.visits_count
  end
  expose :shares_count,  documentation: {required: true, type: "Integer", desc: "分享数量"} do |instance, options|
    instance.information.shares_count
  end
end
