require_relative "boot"
require_relative "api_v1"
require_relative "api_v2"

I18n.enforce_available_locales = false

class ServiceApplication < Grape::API
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :put, :post, :options, :delete]
    end
  end

  format :json

  get do
    {
      name: "inkash platform api",
      versions: [:v1, :v2]
    }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    msg = {
      error: e.message.gsub(/\ \[.*/, "")
    }.to_json
    Rack::Response.new(msg, 404, {"Content-type" => "application/json"}).finish
  end


  helpers AccessHelper
  helpers LocaleHelper
  helpers MapHelper
  helpers UserHelper
  helpers ScripHelper
  helpers FavoriteHelper
  helpers CommentHelper
  helpers ShareHelper
  helpers VisitHelper
  # paginate per_page: 15
  mount ApiV1
  mount ApiV2


  add_swagger_documentation
  get '/(*:url)', :anchor => false do
    error! "Not found! No route mapping to >> #{env["HTTP_HOST"]}/#{env["PATH_INFO"]}", 404
  end

  $host = ENV["INKASH_HOST"] || "http://localhost:9000"

end


