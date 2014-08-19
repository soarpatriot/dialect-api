require 'rails_helper'

describe User, :type => :model do

  it "authenticate user by token" do
    user = create :user, password: "123123123"
    token = user.auth_tokens.create
    res = user.authenticate_by_token token.value
    expect(res.id).to eq(user.id)
    res = user.authenticate_by_token "123"
    expect(res).to eq(false)
  end

  context "create user allocate soundink code " do
    it "allocate soundink code with code nil " do
      user = build :user, nickname: "inkash", soundink_code:nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:service_code]).to eq(["there is no available service code to allocate to user"])
    end
    it "allocate soundink code with available code " do
      create :soundink_code
      user = create :user, nickname: "inkash12121", soundink_code:nil
      user2 = User.where(nickname: "inkash12121").first
      expect(user2.nickname).to eq(user.nickname)
    end
  end


  it "password's length needs to be >= 8" do
    user = build :user, password: "1231231"
    expect(user).not_to be_valid
  end

  it "nickname is unique" do
    create :user, nickname: "inkash"
    user2 = build :user, nickname: "inkash"
    expect(user2).not_to be_valid
    expect(user2.errors.messages[:nickname]).to eq(["has already been taken"])
  end

  it "mobile number is unique" do
    create :user, mobile_number: "13900000000"
    user2 = build :user, mobile_number: "13900000000"
    expect(user2).not_to be_valid
    expect(user2.errors.messages[:mobile_number]).to eq(["has already been taken"])
  end

  context "presence true: " do
    it "nickname is nil" do
      user = build :user, nickname: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:nickname]).to eq(["can't be blank"])
    end
    it "password is nil" do
      user = build :user, nickname:"inkash", password: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:password]).to eq(["can't be blank"])
    end
    it "mobile number is nil" do
      user = build :user, mobile_number: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:mobile_number]).to eq(["can't be blank"])
    end
  end
end
