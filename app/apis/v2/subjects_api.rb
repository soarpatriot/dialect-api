class V2::SubjectsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :subjects do
    
    desc "获取专题详情", {
      entity: SubjectEntity
    }
    params do
      requires :id, type: Integer, desc: "专题ID"
    end
    get ":id" do
      present Subject.first, with: SubjectEntity
    end

  end
end
