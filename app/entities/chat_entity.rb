
class ChatEntity < Grape::Entity
  require 'information_entity'
  include ActionView::Helpers::DateHelper


  expose :id,     documentation: {required: true, type: "Integer", desc: "id"}
  expose :type,   documentation: {required: true, type: "String", desc: "类型"} do |instance, options|
    instance.ctype
  end
  expose :information, if: lambda{|instance, options| instance.ctype == "information" }, using: InformationEntity
  expose :title, documentation: {required: true, type: "String", desc: "聊天标题"} do |instance, options|
    instance.target.name
  end
  expose :target_id, documentation: {required: true, type: "Integer", desc: "目标ID"}
  expose :target_type, documentation: {required: true, type: "Integer", desc: "目标类型"}
  expose :last_message do
    expose :sender_id,       documentation: {required: true, type: "Integer", desc: "最近一个消息的用户ID"} do |instance, options|
      instance.last_sender_id
    end
    expose :sender_nickname,  documentation: {required: true, type: "Integer", desc: "最近一个消息的用户昵称"} do |instance, options|
      instance.last_sender.try(:name)
    end
    expose :sender_avatar_url, documentation: {required: true, type: "Integer", desc: "最近一个消息的用户昵称"} do |instance, options|
      instance.last_sender.try(:avatar_url)
    end
    expose :content,     documentation: {required: true, type: "Integer", desc: "最近的消息"} do |instance, options|
      instance.last_message
    end
    expose :created_at,       documentation: {required: true, type: "Integer", desc: "最近的消息发送时间"} do |instance, options|
      time_ago_in_words instance.updated_at
    end
  end
end
