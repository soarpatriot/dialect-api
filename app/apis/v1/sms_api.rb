class V1::SmsApi < Grape::API

  helpers SmsHelper

  namespace :sms do

    desc "发送用户注册验证码", {
      entity: CaptchaEntity
    }
    params do
      requires :mobile_number, type: String
    end
    post "send_register_code" do
      user = User.where(mobile_number: params[:mobile_number]).first
      locale_error! "user_exsisted", 400 unless user.nil?
      Captcha.where(mobile_number: params[:mobile_number], ctype: "register").delete_all

      captcha = Captcha.create mobile_number: params[:mobile_number], ctype: "register"
      error! captcha.errors.full_messages.join(","), 400 unless captcha.persisted?

      send_captcha captcha.code, params[:mobile_number]

      present captcha, with: CaptchaEntity
    end

    desc "发送用户重置密码验证码", {
      entity: CaptchaEntity
    }
    params do
      requires :mobile_number, type: String
    end
    post "send_reset_password_code" do
      user = User.where(mobile_number: params[:mobile_number]).first
      locale_error! "no_user_with_this_mobile_number", 400 if user.nil?
      Captcha.where(mobile_number: params[:mobile_number], ctype: "reset_password").delete_all

      captcha = Captcha.create mobile_number: params[:mobile_number], ctype: "reset_password"
      error! captcha.errors.full_messages.join(","), 400 unless captcha.persisted?

      send_captcha captcha.code, params[:mobile_number]

      present captcha, with: CaptchaEntity
    end

  end

end
