class V1::UserApi < Grape::API

  namespace :user do

    desc "下载声印码", {
      notes: <<-NOTES
        下载分配给此用户的声印码,返回一个两秒的以service code命名的wav文件，即如果service code为8888，则下载到的文件为8888.wav
      NOTES
    }
    params do
      requires :auth_token, type: String
    end
    get "download_soundink_code" do
      token_authenticate!

      content_type "application/octet-stream"
      header["Content-Disposition"] = "attachment; filename=1001.wav"

      data = File.open(Rails.application.config.root.join("public/soundinkcodes/1001.wav")).read
      env["api.format"] = :binary
      present data
    end

    desc "更新用户信息", {
      entity: UserEntity,
      notes: <<-NOTES
        更新用户的个人信息，不包括密码
      NOTES
    }
    params do
      optional :nickname, type: String, desc: "用户昵称"
      optional :avatar
      optional :gender, type: Symbol, values: [:male, :female, :other]
      requires :auth_token, type: String
    end
    post "update_profile" do
      token_authenticate!
      user_params = {}
      user_params[:nickname] = params[:nickname] if params[:nickname]
      user_params[:avatar] = params[:avatar] if params[:avatar]
      user_params[:gender] = params[:gender] if params[:gender]

      if user_params.keys.any?
        error! current_user.errors.full_messages.join(","), 400 unless current_user.update(user_params)
      end

      present current_user, with: UserEntity
    end

    desc "更新用户密码"
    params do
      requires :current_password, type: String
      requires :new_password, type: String
      requires :auth_token, type: String
    end
    post "change_password" do
      token_authenticate!
      locale_error! "wrong_current_password", 400 unless current_user.authenticate(params[:current_password])

      current_user.update password: params[:new_password]
      error! current_user.errors.full_messages.join(","), 400 if current_user.errors.any?

      present current_user, with: UserEntity
    end

    desc "reset password"
    params do
      requires :mobile_number, type: String
      requires :reset_password_code, type: String
      requires :password, type: String
    end
    post "reset_password" do
      user = User.where(mobile_number: params[:mobile_number]).first
      locale_error! "no_user_with_this_mobile_number", 404 if user.nil?

      captcha = Captcha.where(mobile_number: params[:mobile_number], ctype: Captcha.ctypes[:reset_password], code: params[:reset_password_code]).first
      locale_error! "wrong_register_code", 400 if captcha.nil?

      if user.update password: params[:password]
        captcha.destroy
        present user, with: UserEntity
      else
        error! user.errors.full_messages.join(","), 400
      end
    end

    desc "用户注册", {
      entity: UserEntity
    }
    params do
      requires :country_code, type: Integer
      requires :mobile_number, type: String
      requires :register_code, type: String
      requires :nickname, type: String
      requires :password, type: String
    end
    post "register" do
      user = User.where(country_code: params[:country_code], mobile_number: params[:mobile_number]).first
      locale_error! "user_exsisted", 400 unless user.nil?
      # error! "user with mobile_number #{params[:mobile_number]} existed", 400 unless user.nil?

      captcha = Captcha.where(mobile_number: params[:mobile_number], ctype: Captcha.ctypes[:register], code: params[:register_code]).first
      locale_error! "wrong_register_code", 400 unless params[:register_code] == captcha.try(:code)

      user = User.create country_code: params[:country_code], mobile_number: params[:mobile_number], nickname: params[:nickname], password: params[:password]
      error! user.errors.full_messages.join(","), 400 unless user.persisted?

      captcha.destroy
      user.auth_tokens.create
      present user, with: UserEntity, return_token: true
    end

    desc "用户登陆", {
      entity: UserEntity
    }
    params do
      requires :mobile_number, type: String
      requires :password,      type: String
    end
    post "login" do
      user = User.where(mobile_number: params[:mobile_number]).first
      locale_error! "invalid_mobile_number_or_password", 401 unless user

      res = user.authenticate params[:password]
      locale_error! "invalid_mobile_number_or_password", 401 unless res

      res.auth_tokens.create unless res.auth_tokens.any?
      present res, with: UserEntity, return_token: true
    end

    desc "用户退出"
    params do
      requires :auth_token, type: String
    end
    delete "logout" do
      token_authenticate!
    end

  end

end
