require 'rails_helper'

RSpec.describe Information, :type => :model do
  it "url" do
    information = create :information
    expect(information.url).to eq("test.dev/information/#{information.id}")
  end

  it "belongs to coupon and favorited" do
    coupon = create :coupon, count: 0
    expect(coupon.information.is_coupon_taken?).to eq(true)
  end

  it "soft delete" do
    scrip = create :scrip
    information = scrip.information
    expect(Information.count).to eq(1)
    expect(information.is_destroyed?).to eq(false)
    information.soft_delete
    expect(Information.count).to eq(0)
    expect(Information.unscoped.count).to eq(1)
    information.reload
    expect(information.is_destroyed?).to eq(true)
  end

  it "soft delete | delete favorite" do
    scrip = create :scrip
    create :favorite, information: scrip.information
    expect(Favorite.count).to eq(1)
    scrip.information.soft_delete
    expect(Favorite.count).to eq(0)
  end

  it "soft delete | delete comments of scrip" do
    scrip = create :scrip
    create :comment, scrip: scrip
    information = scrip.information
    expect(scrip.comments.count).to eq(1)
    information.soft_delete
    expect(scrip.comments.count).to eq(0)
  end

  it "increase and decrease count" do
    information = create :information
    expect(information.comments_count).to eq(0)
    information.increase_for :comments_count
    expect(information.comments_count).to eq(1)
    information.decrease_for :comments_count
    expect(information.comments_count).to eq(0)
  end

  it "could not decrease below 0" do
    information = create :information
    expect(information.comments_count).to eq(0)
    information.increase_for :comments_count
    expect(information.comments_count).to eq(1)
    information.decrease_for :comments_count
    information.decrease_for :comments_count
    expect(information.comments_count).to eq(0)
  end
end
