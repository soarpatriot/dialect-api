require "spec_helper"


describe V2::SponsorsApi do
  let(:sponsors_path) { "/v2/sponsors" }

  before(:each) do
    stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
  end

  it "get current sponsors" do
    create :sponsor, start_at: (DateTime.now - 10.days), end_at: (DateTime.now + 10.days), always_show: false, scrip_id: create(:scrip).id, title: "sponsor"
    create :sponsor, start_at: (DateTime.now + 1.days), end_at: (DateTime.now + 10.days), always_show: true, scrip_id: create(:scrip).id
    create :sponsor, start_at: (DateTime.now - 10.days), end_at: (DateTime.now - 1.days), always_show: true, scrip_id: create(:scrip).id
    res = auth_json_get sponsors_path
    expect(res.size).to eq(1)
    expect(res.first[:always_show]).to eq(false)
    expect(res.first[:title]).to eq("sponsor")
  end

end
