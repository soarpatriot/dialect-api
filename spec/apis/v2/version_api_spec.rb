require "rails_helper"

describe V2::VersionApi do
  let(:version_path) { "/v2/versions" }

  context "get version" do
    it "get latest version" do
      version = create :version, platform: "android", code: 101, mandatory: true, url: "http://test.com"
      res = json_get version_path, platform: version.platform
      expect(res[:code]).to eq(version.code)
      expect(res[:platform]).to eq(version.platform)
      expect(res[:mandatory]).to eq(version.mandatory)
      expect(res[:url]).to eq(version.url)
    end
  end

end
