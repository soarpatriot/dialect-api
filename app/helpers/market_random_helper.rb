module MarketRandomHelper

  def random_user
    market_users = User.where group: User.groups[:market]
    market_users.offset(rand(market_users.count)).first
  end

  def random_address
    ContentAddress.offset(rand(ContentAddress.count)).first.try(:value)
  end

end
