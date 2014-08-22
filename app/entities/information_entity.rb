class InformationEntity < Grape::Entity
  include ActionView::Helpers::DateHelper

  expose :id,   documentation: {required: true, type: "Integer", desc: "id"}
  expose :subject_id, if: lambda{|instance, options| instance.is_subject? } do |instance, options|
    instance.infoable_id
  end
  expose :type, documentation: {required: true, type: "String", desc: "类型"} do |instance, options|
    instance.infoable_type
  end
  expose :favorited,      documentation: {required: true, type: "String"} do |instance, options|
    options[:user].favorites.where(information_id: instance.id).any?
  end
  expose :image_url, documentation: {required: true, type: "String", desc: "图片地址"} do |instance, options|
    instance.try(:infoable).try(:image_url)
  end
  expose :thumb_image_url, documentation: {required: true, type: "String", desc: "缩略图片地址"} do |instance, options|
    if instance.is_scrip?
      instance.try(:infoable).try(:image).try(:url, :thumb)
    else
      instance.try(:infoable).try(:image_url)
    end
  end
  expose :middle_image_url, documentation: {required: true, type: "String", desc: "中等尺寸图片地址"} do |instance, options|
    instance.try(:infoable).try(:image_url)
  end
  expose :url,  documentation: {required: true, type: "String", desc: "URL地址"} do |instance, options|
    instance.url + "?auth_token=#{options[:auth_token]}&locale=#{I18n.locale}"
  end
  expose :share_title,  documentation: {required: true, type: "String", desc: "供分享使用的title"} do |instance, options|
    Settings.share_title
  end
  expose :share_url,  documentation: {required: true, type: "String", desc: "供分享使用的URL地址"} do |instance, options|
    instance.share_url + "?locale=#{I18n.locale}"
  end
  expose :owner_id,  documentation: {required: true, type: "String", desc: "owner id"} do |instance, options|
    instance.infoable.try(:owner).try(:id)
  end
  expose :owner_type,  documentation: {required: true, type: "String", desc: "用户类型"} do |instance, options|
    instance.infoable.try(:owner_type)
  end
  expose :owner_nickname,  documentation: {required: true, type: "String", desc: "用户昵称"} do |instance, options|
    if instance.is_scrip?
      instance.try(:infoable).try(:username)
    else
      instance.infoable.try(:owner).try(:name)
    end
  end
  expose :owner_avatar_url,  documentation: {required: true, type: "String", desc: "用户头像URL地址"} do |instance, options|
    if instance.is_scrip?
      instance.try(:infoable).try(:user_avatar)
    else
      instance.infoable.try(:owner).try(:avatar_url)
    end
  end
  expose :place,  documentation: {required: true, type: "String", desc: "地点"} do |instance, options|
    instance.place.try(:name)
  end
  expose :address,  documentation: {required: true, type: "String", desc: "地址"} do |instance, options|
    if instance.place
      instance.place.address
    else
      instance.infoable.try(:address)
    end
  end
  expose :summary,  documentation: {required: true, type: "String", desc: "简述"} do |instance, options|
    instance.infoable.try(:summary)
  end
  expose :created_at,  documentation: {required: true, type: "String", desc: "发布时间"} do |instance, options|
    time_ago_in_words instance.created_at
  end
  expose :comments_count,  documentation: {required: true, type: "Integer", desc: "评论数量"} do |instance, options|
    instance.comments_count
  end
  expose :votes_count,  documentation: {required: true, type: "Integer", desc: "赞数量"} do |instance, options|
    instance.votes_count
  end
  expose :visits_count,  documentation: {required: true, type: "Integer", desc: "浏览数量"} do |instance, options|
    instance.visits_count
  end
  expose :shares_count,  documentation: {required: true, type: "Integer", desc: "分享数量"} do |instance, options|
    instance.shares_count
  end
end
