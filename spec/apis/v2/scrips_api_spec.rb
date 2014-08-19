require "spec_helper"

describe V2::ScripsApi do
  let(:scrips_path) { "/v2/scrips" }

  context "get user's all scrips" do
    let(:scrips){ create_list :scrip, 4, content:"test", owner: current_user }

    before do
      stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
      scrips
    end

    it "default per page, get page 1" do
      res = auth_json_get scrips_path
      expect(res[:data].size).to eq(2)
      expect(res[:has_more]).to eq(true)
    end

  end

  context "paginate by start id and end id" do
    let(:scrips) { create_list :scrip, 4, content:"test", owner: current_user }
    before do
      stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
    end

    it "after_id to get new records" do
      res = auth_json_get scrips_path, after: scrips[3].information.id
      expect(res[:data].size).to eq(0)

      res = auth_json_get scrips_path, after: scrips[2].information.id
      expect(res[:data].size).to eq(1)

      res = auth_json_get scrips_path, after: scrips[0].information.id
      expect(res[:data].size).to eq(2)
    end

    it "before_id to get old records" do
      res = auth_json_get scrips_path, before: scrips[0].information.id
      expect(res[:data].size).to eq(0)

      res = auth_json_get scrips_path, before: scrips[1].information.id
      expect(res[:data].size).to eq(1)

      res = auth_json_get scrips_path, before: scrips[3].information.id
      expect(res[:data].size).to eq(2)
    end
  end

  context "create scrip" do

    it "fails without both content and image" do
      res = auth_json_post scrips_path
      expect(res[:error]).to eq( I18n.t("content_and_image_not_both_null") )
    end

    it "success with subject and place" do
      place = create :place
      subject = create :subject
      res = auth_json_post scrips_path, content: "content", place_id: place.id, subject_id:subject.id
      expect(current_user.scrips.count).to eq(1)
      scrip = current_user.scrips.first

      expect(subject.informations.first.id).to eq(scrip.information.id)
      expect(res[:id]).to eq(scrip.information.id)
    end

    it "with image file" do
      place = create :place
      subject = create :subject
      image_path = "#{G2.config.root_dir}/app/assets/images/emotion/face_angry.png"
      # fixture_file_upload(image_path, 'image/png')
      res = auth_json_post scrips_path, content: "content", place_id: place.id, subject_id:subject.id, image: File.new(image_path)

      expect(current_user.scrips.count).to eq(1)
      scrip = current_user.scrips.first

      expect(subject.informations.first.id).to eq(scrip.information.id)
      expect(res[:id]).to eq(scrip.information.id)
    end

  end
end
