class UserMailer < ActionMailer::Base

  default from: "dandelion@soundink.cn"

  def activate user
    @user = user
    code = Digest::SHA2.hexdigest(user.email + "#{user.email}ssp#{Time.now.to_i}")
    UserInvitationToken.create user: user, token: code
    @url  = "#{$host}/activate.html?token=#{code}"
    mail to: user.email, subject: 'SoundInk SSP系统账户激活' do |format|
      format.html
    end
  end

end
