class ReportEntity < Grape::Entity
  expose :id,             documentation: {required: true, type: "Integer", desc: "id"}
  expose :user_id,        documentation: {required: true, type: "Integer", desc:"reporter id"}
  expose :information_id, documentation: {required: true, type: "Integer", desc:"Information id"}
  expose :created_at,     documentation: {required: true, type: "String", desc: "举报时间"}
end
