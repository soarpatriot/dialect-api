class V2::SponsorsApi < Grape::API
  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :sponsors do

    desc "获取当前用户的所有纸条", {
      entity: SponsorEntity
    }
    get do
      now = DateTime.now
      sponsors = Sponsor.where("start_at < ? and end_at > ?", now, now)
      present sponsors, with: SponsorEntity, auth_token: params[:auth_token]
    end

  end
end
