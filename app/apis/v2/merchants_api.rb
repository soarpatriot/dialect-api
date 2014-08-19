class V2::MerchantsApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :merchants do

    desc "checkin by mq100", {
        entity: CheckinHistoryEntity
    }
    params do
      requires :merchant_service_code, type: String
      optional :geolocation, type: String, regexp: /^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/, desc: "lon,lat"
    end
    post "checkin" do
      merchant = Mq100.where(service_code: params[:merchant_service_code]).first.try(:merchant)
      error! "couldn't find mq100 with this service code #{params[:service_code]}", 404 if merchant.nil?

      ch_params = {
          merchant_id: merchant.id
      }
      if params[:geolocation]
        lon, lat = params.split(",")
        ch_params[:longitude] = lon
        ch_params[:latitude] = lat
      end
      ch = current_user.checkin_histories.create ch_params
      present ch, with: CheckinHistoryEntity
    end

  end

end
