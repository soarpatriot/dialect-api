require "spec_helper"

describe V1::FriendsApi do
  let(:friends_path) { "/v2/friends" }

  it "get current user's friends" do
    res = auth_json_get friends_path
    expect(res.size).to eq(0)

    user = create :user
    current_user.friends << user

    res = auth_json_get friends_path
    expect(res.size).to eq(1)
    expect(current_user.friends.count).to eq(1)
    expect(user.friends.count).to eq(1)
  end

end
