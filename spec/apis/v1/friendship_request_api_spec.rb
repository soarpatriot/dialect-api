require "spec_helper"

describe V1::FriendshipRequestApi do
  let(:new_path) { "/v2/friendship_request/new" }
  let(:cancel_path) { "/v2/friendship_request/cancel" }
  let(:accept_path) { "/v2/friendship_request/accept" }
  let(:status_path) { "/v2/friendship_request/status" }

  it "new" do
    res = auth_json_post new_path
    expect(FriendshipRequest.count).to eq(1)
    expect(res[:source_user_id]).to eq(current_user.id)
  end

  it "cancel" do
    current_user.friendship_requests.create status: "waiting"
    expect(current_user.friendship_requests.count).to eq(1)
    auth_json_post cancel_path
    expect(current_user.friendship_requests.count).to eq(0)
  end

  it "status" do
    current_user.friendship_requests.create status: "waiting"
    res = auth_json_get status_path
    expect(res[:source_user_id]).to eq(current_user.id)
  end

  it "status | no friendship requests" do
    res = auth_json_get status_path
    expect(res[:error]).to eq("couldn't find any friendship request")
  end

  it "accept | success" do
    user = create :user
    user.friendship_requests.create status: "waiting"
    res = auth_json_post accept_path, service_code: user.service_code
    expect(res[:source_user_id]).to eq(user.id)
    expect(res[:target_user_id]).to eq(current_user.id)
    user.reload
    current_user.reload
    expect(user.friends.include?(current_user)).to eq(true)
    expect(current_user.friends.include?(user)).to eq(true)
  end

  it "accept | already been friend" do
    user = create :user
    user.friends << current_user
    user.friendship_requests.create status: "waiting"
    res = auth_json_post accept_path, service_code: user.service_code
    expect(res[:error]).to eq("already been friend")
  end

  it "accept | no friendship requests" do
    user = create :user
    res = auth_json_post accept_path, service_code: user.service_code
    expect(res[:error]).to eq("couldn't find any friendship_requests of this user")
  end
end
