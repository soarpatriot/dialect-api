require "grape-swagger"
class ApiV1 < Grape::API

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :put, :post, :options, :delete]
    end
  end

  include Grape::Kaminari
  version :v1
  format :json
  paginate per_page: 15

  before do
    I18n.locale = params[:locale] if I18n.locale_available?(params[:locale])
  end

  get do
    {
        name: "v1"
    }
  end


  helpers AccessHelper
  helpers LocaleHelper
  helpers ApplicationHelper

  mount V1::UserApi
  mount V1::PostsApi
  add_swagger_documentation  api_version:"v1", base_path: (ENV["INKASH_HOST"] || "http://localhost:9000")
  #add_swagger_documentation
  # add_swagger_documentation api_version: "v1", markdown: true
  # add_swagger_documentation api_version: "v2", markdown: true
end
