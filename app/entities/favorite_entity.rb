class FavoriteEntity < Grape::Entity
  expose :information_id, documentation: {required: true, type: "Integer"}
  expose :user_id,        documentation: {required: true, type: "Integer"}
  expose :favorited,      documentation: {required: true, type: "String"}
end
