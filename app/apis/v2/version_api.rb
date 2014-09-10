class V2::VersionApi < Grape::API

  resources :versions do
    desc "返回最新版本", {
        entity: VersionEntity
    }
    params do
      requires :platform, type: Symbol, values: [:ios, :android,:"ios-beta"], desc: "系统平台 ios android"
    end
    get do
      version = Version.where(platform: params[:platform]).first
      present version, with: VersionEntity
    end
  end

end
