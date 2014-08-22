require 'rails_helper'

RSpec.describe Scrip, :type => :model do

  context "associations" do
    before(:each) do
      stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
    end

    it "destroy related information after self destroied" do
      scrip = create :scrip
      expect(Scrip.count).to eq(1)
      expect(Information.count).to eq(1)
      scrip.destroy
      expect(Scrip.count).to eq(0)
      expect(Information.count).to eq(0)
    end

    it "destroy related favorite after self destroied" do
      scrip = create :scrip
      create :favorite, information: scrip.information
      expect(Scrip.count).to eq(1)
      expect(Favorite.count).to eq(1)
      scrip.destroy
      expect(Scrip.count).to eq(0)
      expect(Favorite.count).to eq(0)
    end
  end

  context "geolocation" do
    it "geocode if address blank" do
      stub_request(:get, map_api_url(39.400, 123.123)).to_return(body: map_api_result)
      binding.pry
      scrip = create :scrip, address:""
      expect(scrip.address).to eq("辽宁省大连市长海县")

      scrip = create :scrip, address: "address"
      expect(scrip.address).to eq("address")
    end
  end

  context "random record" do
    before(:each) do
      stub_request(:get, map_api_url(39.400, 123.123)).to_return(body: map_api_result)
    end

    it "get record" do
      s1 = create :scrip
      u1 = create :user
      u2 = create :user

      s2 = Scrip.random_record_for u1, nil, nil
      create :information_visit_record, information: s2.information, user: u1
      expect(s1.id).to eq(s2.id)

      s2 = Scrip.random_record_for u1, nil, nil
      expect(s2).to eq(nil)

      s2 = Scrip.random_record_for u2, nil, nil
      create :information_visit_record, information: s2.information, user: u1
      expect(s1.id).to eq(s2.id)

      s2 = Scrip.random_record_for u1, nil, nil
      expect(s2).to eq(nil)
    end
  end

  context "address" do
    before(:each) do
      stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
    end
    it "union blank address" do
      s1 = create :scrip
      expect(s1.union_address).to eq("")
    end
    it "union pieces address" do
      s1 = create :scrip, country:"China", city:"Beijing"
      expect(s1.union_address).to eq("China,Beijing")
    end
    it "union integrate address" do
      s1 = create :scrip, country:"China", province:"Hebei",city:"Shijiazhuang",district:"heping District",street:"Shengli lu No 2"
      expect(s1.union_address).to eq("China,Hebei,Shijiazhuang,heping District,Shengli lu No 2")
    end
  end

  context "owner username" do
    it "has username" do
      scrip = create :scrip
      username = scrip.owner.name
      expect(scrip.username).to eq(username)
      scrip.owner.update nickname: "new name"
      expect(scrip.username).to eq(username)
    end
  end

  context "geolocation aware" do
    it "find 1" do
      u1 = create :user
      scrip = create :scrip, latitude: 1.0, longitude: 1.0
      create :scrip, latitude: 10.0, longitude: 10.0
      s2 = Scrip.random_record_for u1, nil, "1.0,1.0"
      expect(s2.id).to eq(scrip.id)
    end

    it "find none" do
      allow(Kernel).to receive(:rand).with(2) { 0 }
      u1 = create :user
      create :scrip, latitude: 10.0, longitude: 10.0
      scrip = create :scrip, latitude: 1.0, longitude: 1.0
      s2 = Scrip.random_record_for u1, nil, "0.0,0.0"
      expect(s2.id).to eq(scrip.id)
    end
  end

end
