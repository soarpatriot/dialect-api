class V2::DevicesApi < Grape::API

  before do
    token_authenticate!
  end

  params do
    requires :auth_token, type: String
  end
  resources :devices do
    
    desc "注册设备", {
      notes: <<-NOTES
        success: {registered: true}
        fail: {registered: false}
      NOTES
    }
    params do
      requires :platform, type: Symbol, values: [:ios, :android], desc: "系统平台 ios android"
      requires :device_token, type: String, desc: "用于推送消失使用的token"
    end
    post "register" do
      device = Device.where(platform: params[:platform], token: params[:device_token]).first_or_create
      device.update user: current_user, status: Device.statuses[:active]

      current_user.devices.where("id <> ?", device.id).each do |_device|
        _device.inactive!
      end

      if device
        {registered: true}
      else
        {registered: false}
      end
    end

  end
end
