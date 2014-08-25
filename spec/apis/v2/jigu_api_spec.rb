require "spec_helper"

describe V2::JiguApi do

  let(:jigu_path) { "/v2/jigu" }
  let(:jigu_checkin_path) { "/v2/jigu/checkin" }

  def jigu_list_path params={}
    url = "/v2/jigu/list"
    url = url + "?place_id=#{params[:place_id]}"
    if params[:subject_id]
      url = url + "&subject_id=#{params[:subject_id]}"
    end
    if params[:place_id] or params[:subject_id] and params[:before]
      url = url + "&before=#{params[:before]}"
    end
    url
  end

  context "jigu" do
    context "first" do
      it "get coupon" do
        current_user.update country_code: 65
        allow(Kernel).to receive(:rand).with(2) { 1 }

        mq100 = create :mq100
        create :coupon, owner: mq100.merchant
        coupon = create :coupon, owner: mq100.merchant

        res = auth_json_get jigu_path
        expect(res[:id]).to eq(coupon.information.id)
        expect(InformationVisitRecord.count).to eq(1)
        expect(Favorite.count).to eq(1)
        coupon.reload
        expect(coupon.count).to eq(9)
      end
    end

    context "without service code" do
      before(:each) do
        create :information_visit_record, user: current_user
      end

      it "scrip" do
        allow(Kernel).to receive(:rand).with(1) { 0 }
        scrip = create :scrip
        # scrip is order by id desc
        res = auth_json_get jigu_path
        expect(res[:id]).to eq(scrip.information.id)
      end

      it "create information visit record" do
        allow(Kernel).to receive(:rand).with(1) { 0 }
        create :scrip
        auth_json_get jigu_path
        expect(InformationVisitRecord.count).to eq(2)
      end

      it "no duplicate scrip" do
        allow(Kernel).to receive(:rand).with(1) { 0 }

        s1 = create :scrip

        res = auth_json_get jigu_path
        expect(res[:id]).to eq(s1.information.id)

        s2 = create :scrip

        res = auth_json_get jigu_path
        expect(res[:id]).to eq(s2.information.id)
      end

      it "no more scrip" do
        res = auth_json_get jigu_path
        expect(res[:id]).to eq(-1)
        expect(res[:url]).to eq("#{Settings.host}/information/no_scrip?locale=")
      end
    end

    context "with service code" do
      let(:mq100) { create :mq100 }

      before(:each) do
        create :information_visit_record, user: current_user
      end

      it "coupon enough count" do
        allow(Kernel).to receive(:rand).with(2) { 1 }
        allow(Kernel).to receive(:rand).with(5) { 4 }

        create_list :coupon, 4, owner: mq100.merchant
        coupon = create :coupon, owner: mq100.merchant

        res = auth_json_get jigu_path, service_code: mq100.service_code

        expect(res[:id]).to eq(coupon.information.id)

        coupon.reload
        expect(coupon.count).to eq(9)
        expect(current_user.favorites.count).to eq(1)
        expect(current_user.favorites.first.information).to eq(coupon.information)
      end

      it "scrip | no coupon" do
        allow(Kernel).to receive(:rand).with(2) { 1 }
        allow(Kernel).to receive(:rand).with(0) { 0.1 }
        allow(Kernel).to receive(:rand).with(1) { 0 }

        scrip = create :scrip, title: "system_notice"

        res = auth_json_get jigu_path, service_code: mq100.service_code

        expect(res[:id]).to eq(scrip.information.id)
      end

      it "scrip | favorited" do
        scrip = create :scrip
        create :favorite, information: scrip.information, user: current_user
        res = auth_json_get jigu_path
        expect(res[:favorited]).to eq(true)
      end

      it "scrip | get latest" do
        allow(Kernel).to receive(:rand).with(2) { 0 }
        allow(Kernel).to receive(:rand).with(5) { 4 }

        create_list :scrip, 4
        scrip = create :scrip

        res = auth_json_get jigu_path, service_code: mq100.service_code

        expect(res[:id]).to eq(scrip.information.id)
      end
    end
  end

  context "list" do
    it "get jigu list of current place" do
      place = create :place
      scrip = create :scrip
      scrip.information.update place_id: place.id

      place2 = create :place
      scrip2 = create :scrip
      scrip2.information.update place_id: place2.id

      res = auth_json_get jigu_list_path(place_id: place.id)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)

      scrips = create_list :scrip, 2
      scrips.each do |item|
        item.information.update place_id: place.id
      end

      res = auth_json_get jigu_list_path(place_id: place.id)
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(2)

      res = auth_json_get jigu_list_path(place_id: place.id, before: scrips.first.information.id)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
      expect(res[:data].first[:id]).to eq(scrip.information.id)
    end

    it "get first jigu of a new place" do
      place = create :place
      res = auth_json_get jigu_list_path(place_id: place.id)
    end

    it "get jigu list of current subject" do
      place = create :place
      subject = create :subject
      scrip = create :scrip
      scrip.information.update subject_id: subject.id, place_id: place.id

      subject2 = create :subject
      scrip2 = create :scrip
      scrip2.information.update subject_id: subject2.id

      res = auth_json_get jigu_list_path(place_id: place.id, subject_id: subject.id)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)

      scrips = create_list :scrip, 2
      scrips.each do |item|
        item.information.update subject_id: subject.id, place_id: place.id
      end

      res = auth_json_get jigu_list_path(place_id: place.id, subject_id: subject.id)
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(2)

      res = auth_json_get jigu_list_path(place_id: place.id, subject_id: subject.id, before: scrips.first.information.id)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
      expect(res[:data].first[:id]).to eq(scrip.information.id)
    end
  end

  it "checkin" do
    mq100 = create :mq100
    res = auth_json_post jigu_checkin_path, merchant_service_code: mq100.service_code, geolocation: "123,123"
    expect(CheckinHistory.count).to eq(1)

    ch = CheckinHistory.first
    expect(res[:id]).to eq(ch.id)
    expect(res[:merchant]).to eq(mq100.merchant.name)
  end
end
