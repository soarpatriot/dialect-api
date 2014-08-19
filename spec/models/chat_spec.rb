require 'rails_helper'

describe Chat, :type => :model do
  it "create information favorite type chat" do
    scrip = create :scrip
    sender1 = create :user
    sender2 = create :user
    Chat.create_for_information_favorite scrip.information, sender1
    Chat.create_for_information_favorite scrip.information, sender2
    expect(Chat.count).to eq(1)
  end

  it "create information comment type chat" do
    scrip = create :scrip
    sender1 = create :user
    sender2 = create :user
    Chat.create_for_information_comment scrip.information, sender1, "comment1"
    Chat.create_for_information_comment scrip.information, sender2, "comment2"
    expect(Chat.count).to eq(1)
  end
end
