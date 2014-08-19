require "spec_helper"


describe V2::CommentsApi do
  let(:comments_path) { "/v2/comments" }

  before do
    stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
  end

  it "since" do
    scrip = create :scrip, owner: current_user
    comment = scrip.comments.create content: "test", user: current_user
    res = auth_json_get comments_path, {since: Time.new(2014, 7, 7).to_i}
    expect(res[:data].size).to eq(1)
    expect(res[:data].first[:id]).to eq(comment.id)
    expect(res[:data].first[:user_id]).to eq(comment.user_id)
    expect(res[:data].first[:information_id]).to eq(scrip.information.id)
  end

  it "no since" do
    scrip = create :scrip, owner: current_user
    scrip.comments.create content: "test", created_at: (DateTime.now - 1.days)
    res = auth_json_get comments_path
    expect(res[:data].size).to eq(0)
  end

  context "information's" do
    it "first page" do
      scrip = create :scrip, owner: current_user
      create_list :comment, 3, scrip: scrip
      res = auth_json_get "#{comments_path}?information_id=#{scrip.information.id}"
      expect(res[:data].size).to eq(2)
      expect(res[:has_more]).to eq(true)
    end

    it "has no more" do
      scrip = create :scrip, owner: current_user
      create_list :comment, 2, scrip: scrip
      res = auth_json_get "#{comments_path}?information_id=#{scrip.information.id}"
      expect(res[:data].size).to eq(2)
      expect(res[:has_more]).to eq(false)
    end

    it "before" do
      scrip = create :scrip, owner: current_user
      comments = create_list :comment, 2, scrip: scrip
      res = auth_json_get "#{comments_path}?information_id=#{scrip.information.id}&before=#{comments.last.id}"
      expect(res[:data].size).to eq(1)
      expect(res[:has_more]).to eq(false)
    end
  end

  context "create" do

    it "no place" do
      scrip = create :scrip
      place = Place.new(id:11010101)
      address = "北京东四"
      content = "a new comment"
      res = auth_json_post comments_path, {content: content, address:address, information_id: scrip.information.id, place_id: place.id}
      # expect(res[:error]).to eq(I18n.t('comments.no_place_found'))
      expect(res[:place_id]).to eq(nil)
      #expect(res[:place_id]).to eq(I18n.t('comments.no_place_found'))
    end

    it "success" do
      scrip = create :scrip
      place = create :place
      address = "北京东四"
      content = "a new comment"
      res = auth_json_post comments_path, {content: content, address:address, information_id: scrip.information.id, place_id: place.id}
      expect(Comment.count).to eq(1)
      comment = Comment.first
      expect(res[:id]).to eq(comment.id)
      expect(res[:user_id]).to eq(comment.user_id)
      expect(res[:information_id]).to eq(scrip.information.id)
      expect(res[:content]).to eq(content)
      expect(res[:address]).to eq(address)
    end
  end

end
