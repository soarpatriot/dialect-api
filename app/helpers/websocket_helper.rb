module WebsocketHelper
  
  def current_user
    @current_user ||= User.where(id: params[:user_id]).first
  end

end
