class CommentEntity < Grape::Entity
  include ActionView::Helpers::AssetUrlHelper
  include ActionView::Helpers::DateHelper

  expose :id,    documentation: {required: true, type: "Integer", desc: "评论id"}
  expose :information_id,    documentation: {required: true, type: "Integer", desc: "信息id"} do |instance, options|
    instance.scrip.information.id
  end
  expose :user_avatar_url,    documentation: {required: true, type: "Integer", desc: "评论用户头像"} do |instance, options|
    if instance.user.is_non_login?
      Settings.asset_host + "/assets" + asset_url("avatars/#{rand(10) + 1}.jpg")
    else
      instance.user.avatar_url
    end
  end
  expose :user_nickname,    documentation: {required: true, type: "Integer", desc: "评论用户昵称"} do |instance, options|
    if instance.user.is_non_login?
      I18n.t("users.non_login")
    else
      instance.user.nickname
    end
  end
  expose :address,    documentation: {required: true, type: "Integer", desc: "评论地址"}
  expose :user_id,    documentation: {required: true, type: "Integer", desc: "评论用户id"}
  expose :place_id,   documentation: {required: true, type: "Integer", desc: "评论用户place id"}
  expose :created_at, documentation: {required: true, type: "Integer", desc: "用户添加评论的时间"} do |instance, options|
    time_ago_in_words instance.created_at
  end
  expose :content, documentation: {required: true, type: "Integer", desc: "评论内容"}
end
