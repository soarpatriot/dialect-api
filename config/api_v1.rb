class ApiV1 < Grape::API

  format :json

  before do
    I18n.locale = params[:locale] if I18n.locale_available?(params[:locale])
  end

  get do
    {
      version: "v1"
    }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    msg = {
      error: e.message.gsub(/\ \[.*/, "")
    }.to_json
    Rack::Response.new(msg, 404, {"Content-type" => "application/json"}).finish
  end



  version :v1

  mount V1::ScripsApi
  mount V1::CollectionsApi
  mount V1::InformationsApi

  version [:v1, :v2]

  mount V1::JiguApi
  mount V1::UserApi
  mount V1::CouponsApi
  mount V1::CouponGiveRequestApi
  mount V1::FriendsApi
  mount V1::FriendshipRequestApi
  mount V1::SmsApi
  mount V1::SystemApi

  # add_swagger_documentation api_version: "v1"

end
