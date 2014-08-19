class FriendshipRequestEntity < Grape::Entity
  expose :source_user_id,         documentation: {required: true, type: "Integer"} do |instance, options|
    instance.user_id
  end
  expose :target_user_id,         documentation: {required: true, type: "Integer"}
  expose :target_user_nickname,   documentation: {required: true, type: "String"} do |instance, options|
    instance.target_user.try(:nickname)
  end
  expose :target_user_avatar_url, documentation: {required: true, type: "String"} do |instance, options|
    instance.target_user.try(:avatar_url)
  end
  expose :status,                 documentation: {required: true, type: "String"}
end
