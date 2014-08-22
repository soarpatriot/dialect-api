require "rails_helper"

describe V2::CollectionsApi do
  let(:collections_path) { "/v2/collections" }

  context "paginate by start id and end id" do
    let(:favorites) {
      scrips = create_list :scrip, 4
      scrips.map do |scrip|
        create :favorite, information: scrip.information, user: current_user
      end
    }

    before do
      favorites
    end

    it "default per page, get page 1" do
      res = auth_json_get collections_path
      expect(res[:data].size).to eq(2)
      expect(res[:has_more]).to eq(true)
    end

    it "after_id to get new records" do
      res = auth_json_get collections_path, after: favorites[2].id
      expect(res[:data].size).to eq(1)
      expect(res[:has_more]).to eq(false)

      res = auth_json_get collections_path, after: favorites[0].id
      expect(res[:data].size).to eq(2)
      expect(res[:has_more]).to eq(true)
    end

    it "before_id to get old records" do
      res = auth_json_get collections_path, before: favorites[0].id
      expect(res[:data].size).to eq(0)
      expect(res[:has_more]).to eq(false)

      res = auth_json_get collections_path, before: favorites[1].id
      expect(res[:data].size).to eq(1)
      expect(res[:has_more]).to eq(false)

      res = auth_json_get collections_path, before: favorites[3].id
      expect(res[:data].size).to eq(2)
      expect(res[:has_more]).to eq(true)
    end
  end
end
