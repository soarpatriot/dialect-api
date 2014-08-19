require "grape-swagger"

class ApiV2 < Grape::API
  include Grape::Kaminari

  format :json

  before do
    I18n.locale = params[:locale] if I18n.locale_available?(params[:locale])
  end

  get do
    {
      version: "v2"
    }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    msg = {
      error: e.message.gsub(/\ \[.*/, "")
    }.to_json
    Rack::Response.new(msg, 404, {"Content-type" => "application/json"}).finish
  end

  paginate per_page: 15


  version :v2

  mount V2::JiguApi
  mount V2::PlacesApi
  mount V2::ChatsApi
  mount V2::DevicesApi
  mount V2::SubjectsApi
  mount V2::ScripsApi
  mount V2::CollectionsApi
  mount V2::MerchantsApi
  mount V2::InformationsApi
  mount V2::CommentsApi
  mount V2::SponsorsApi
  mount V2::FeedbacksApi
  mount V2::GeocoderApi
  mount V2::UserApi
  mount V2::VersionApi

  #add_swagger_documentation api_version: "v2", markdown: true

end
