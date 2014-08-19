class V1::CollectionsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :collections do

    desc "获取用户的所有收藏", {
      entity: InformationEntity
    }
    params do
      optional :type, type: Symbol, values: [:Scrip, :Coupon], desc: "信息类型"
    end
    get do
      informations =  Information.joins(:favorites).where("favorites.user_id = #{current_user.id}").order("favorites.created_at desc")
      if params[:type]
        informations =  informations.where(infoable_type: params[:type])
      end
      present informations, with: InformationEntity, auth_token: params[:auth_token], user: current_user
    end

  end

end
