class InformEntity < Grape::Entity
  expose :id,     documentation: {required: true, type: "Integer", desc: "id"}
  expose :type,   documentation: {required: true, type: "String", desc: "类型"} do |instance, options|
    instance.ctype
  end
  expose :information, if: lambda{|instance, options| instance.ctype == "information" }, using: InformationEntity
  expose :title, documentation: {required: true, type: "String", desc: "聊天标题"} do |instance, options|
    if instance.information_id
      instance.last_sender.nickname
    else
      instance.target.name
    end
  end

  expose :updated_at, documentation: {required: true, type: "Integer", desc: "update time"} do |instance, options|
    instance.updated_at.to_i
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
      instance.created_at.to_i
    end
  end

  expose :user_messages ,if: lambda { |instance, options| instance.target_type == "User" } do |instance, options|
    data = []
    instance.unread_messages.each do |message|
        from = {
            type: "User",
            id: instance.target.try(:id),
            avatar: instance.target.try(:avatar_url),
            name: instance.target.name

        }
        to = {
            type: "User",
            id: instance.owner.try(:id),
            avatar: instance.owner.try(:avatar_url),
            name: instance.owner.try(:name),
        }
        s = {
            message_id: message.id,
            from:from,
            to: to,
            type:'text',
            content: message.content,
            timestamp: message.created_at.to_i
        }
        data << s
    end
    instance.unread_messages.delete_all
    instance.destroy
    data

  end


  expose :place_messages ,if: lambda { |instance, options| instance.target_type == "Place" } do |instance, options|
    data = []
    instance.place_messages.each do |message|

      from = {
          type: "User",
          id: message.user_id,
          avatar: message.avatar,
          name: message.name,
      }
      to = {
          type: "Place",
          id: instance.target.try(:id),
          avatar: instance.target.try(:image_url),
          name: instance.target.try(:name),

      }

      s = {
          message_id: message.id,
          from:from,
          to: to,
          type:'text',
          content: message.content,
          timestamp: message.created_at.to_i
      }
      data << s
    end
    data

  end

end
