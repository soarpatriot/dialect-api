class CheckinHistoryEntity < Grape::Entity
  expose :id, documentation: {required: true, type: "Integer"}
  expose :merchant, documentation: {required: true, type: "String"} do |instance, options|
    instance.merchant.name
  end
end
