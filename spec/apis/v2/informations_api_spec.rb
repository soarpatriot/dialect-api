require "spec_helper"


describe V2::InformationsApi do

  def favorite_path information
    "/v2/informations/#{information.id}/favorite"
  end

  def information_path information
    "/v2/informations/#{information.id}"
  end

  def report_path information
    "/v2/informations/#{information.id}/report"
  end

  def visit_path information
    "/v2/informations/#{information.id}/visit"
  end

  def share_path information
    "/v2/informations/#{information.id}/share_statistic"
  end

  def users_favorite_path information
    "/v2/informations/#{information.id}/users/favorited"
  end

  def users_commented_path information
    "/v2/informations/#{information.id}/users/commented"
  end

  def users_visited_path information
    "/v2/informations/#{information.id}/users/visited"
  end

  def users_shared_path information
    "/v2/informations/#{information.id}/users/shared"
  end

  it "add to favorite" do
    scrip = create :scrip
    information = scrip.information
    res = auth_json_post favorite_path(information)

    expect(current_user.favorites.count).to eq(1)
    expect(res[:user_id]).to eq(current_user.id)
    expect(res[:id]).to eq(information.id)
    expect(res[:favorite_id]).to eq(current_user.favorites.first.id)
    expect(res[:favorited]).to eq(true)
  end

  it "add coupon to favorite" do
    coupon = create :coupon
    expect(coupon.count).to eq(10)
    auth_json_post favorite_path(coupon.information)
    expect(current_user.favorites.count).to eq(1)
    coupon.reload
    expect(coupon.count).to eq(9)
  end

  it "remove from favorites" do
    scrip = create :scrip
    favorite = create :favorite, user: current_user, information: scrip.information
    expect(current_user.favorites.count).to eq(1)
    res = auth_json_delete favorite_path(favorite.information)
    expect(current_user.favorites.count).to eq(0)
    expect(res[:favorited]).to eq(false)
  end

  context "delete" do
    before do
      stub_request(:get, map_api_url(39.4, 123.123)).to_return(body: map_api_result)
    end

    it "valid id" do
      scrip = create :scrip, owner: current_user
      res = auth_json_delete information_path(scrip.information)
      expect(res[:id]).to eq(scrip.information.id)
      expect(Scrip.count).to eq(0)
      expect(Information.count).to eq(0)
    end

    it "invalid id" do
      scrip = create :scrip
      res = auth_json_delete information_path(scrip.information)
      expect(res[:error]).to eq(I18n.t("information.invalid_id"))
      expect(Scrip.count).to eq(1)
      expect(Information.count).to eq(1)
    end
  end

  context "report" do
    it "Information id invalid" do
      information = Information.new(id:1010101)
      res = auth_json_post report_path(information)
      expect(res[:error]).to eq("Couldn't find Information with 'id'=1010101")
    end

    it "new report scrip" do
      information = create :information, infoable: create(:scrip)
      res = auth_json_post report_path(information)
      expect(Report.count).to eq(1)
      expect(res[:reported]).to eq(true)
    end

    it "update report scrip" do
      information = create :information, infoable: create(:scrip)
      report = create :report, information: information, user: current_user
      res = auth_json_post report_path(information)
      expect(1).to eq(Report.count)
    end
  end

  context "share" do
    it "share success" do
      information = create :information, infoable: create(:scrip)
      res = auth_json_put share_path(information)
      expect(InformationShareRecord.count).to eq(1)
      expect(res[:count]).to eq(1)
    end

    it "no information" do
      information = Information.new(id:1010101)
      res = auth_json_put share_path(information)
      expect(res[:error]).to eq("Couldn't find Information with 'id'=1010101")
    end

    it "invalid information" do
      information = create :information, infoable: create(:coupon)
      res = auth_json_put share_path(information)
      expect(res[:error]).to eq(I18n.t("information.invalid_id"))
    end
  end

  context "visit" do

    it "visit" do
      information = create :information, infoable: create(:scrip)
      res = auth_json_post visit_path(information)
      expect(InformationVisitRecord.count).to eq(1)
      expect(res[:visited]).to eq(true)
    end

    it "no information" do
      information = Information.new(id:1010101)
      res = auth_json_post visit_path(information)
      expect(res[:error]).to eq("Couldn't find Information with 'id'=1010101")
    end

    it "invalid information" do
      information = create :information, infoable: create(:coupon)
      res = auth_json_post visit_path(information)
      expect(res[:error]).to eq(I18n.t("information.invalid_id"))
    end
  end

  context "users favorited" do
    it "no favorited" do
      information = create :information, infoable: create(:scrip)
      res = auth_json_get users_favorite_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
      #expect(0).to eq(res.count)
    end
    it "one user favorited" do
      information2 = create :information, infoable: create(:scrip)
      create :favorite, information: information2, user: current_user
      information = create :information, infoable: create(:scrip)
      create :favorite, information: information, user: current_user
      res = auth_json_get users_favorite_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end
    it "two user favorited" do
      user = create :user
      information = create :information, infoable: create(:scrip)
      create :favorite, information: information, user: current_user
      create :favorite, information: information, user: user
      res = auth_json_get users_favorite_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(2)
    end

    it "more favorited,get one page" do
      count = Settings.paginate_per_page*10
      information = create :information, infoable: create(:scrip)
      create_list(:favorite, count, information: information )
      res = auth_json_get users_favorite_path(information)
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "more favorited,has before" do
      count = Settings.paginate_per_page*10
      information = create :information, infoable: create(:scrip)
      create_list(:favorite, count, information: information )
      favorite = create(:favorite,information: information )
      res = auth_json_get users_favorite_path(information), before: favorite.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "more favorited,no before" do
      count = Settings.paginate_per_page*10
      information = create :information, infoable: create(:scrip)
      favorite = create(:favorite,information: information )
      create_list(:favorite, count, information: information )
      res = auth_json_get users_favorite_path(information), before: favorite.user.id
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "more favorited,has after" do
      count = Settings.paginate_per_page*10
      information = create :information, infoable: create(:scrip)
      favorite = create(:favorite,information: information )
      create_list(:favorite, count, information: information )
      res = auth_json_get users_favorite_path(information), after: favorite.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "more favorited,has before and after" do
      count = Settings.paginate_per_page*5
      information = create :information, infoable: create(:scrip)
      create_list(:favorite, count, information: information )
      favorite = create(:favorite,information: information )
      create_list(:favorite, count, information: information )

      res = auth_json_get users_favorite_path(information), after: favorite.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
      res = auth_json_get users_favorite_path(information), after: favorite.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end
  end

  context "users commented" do

    it "no comment" do
      information = create :information, infoable:  create(:scrip)
      res = auth_json_get users_commented_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end
    it "one user comment" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create :comment, scrip:scrip, user: current_user
      res = auth_json_get users_commented_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end


    it "duplicated user comment,show two user" do
      scrip = create(:scrip)
      information = create :information, infoable:scrip
      create :comment, scrip:scrip, user: current_user
      create :comment, scrip:scrip, user: current_user
      res = auth_json_get users_commented_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(2)
    end

    it "more commented,get one page" do
      count = Settings.paginate_per_page*10
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create_list(:comment, count, scrip: scrip )
      res = auth_json_get users_commented_path(information)
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "more commented,has before" do
      count = Settings.paginate_per_page*10
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create_list(:comment, count, scrip: scrip)
      comment = create(:comment,scrip: scrip )
      res = auth_json_get users_commented_path(information), before: comment.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "more commented,no before" do
      count = Settings.paginate_per_page*10
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      comment = create(:comment,scrip: scrip )
      create_list(:comment, count, scrip: scrip )
      res = auth_json_get users_commented_path(information), before: comment.user.id
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "more commented,has after" do
      count = Settings.paginate_per_page*10
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      comment = create(:comment,scrip: scrip )
      create_list(:comment, count, scrip: scrip)
      res = auth_json_get users_commented_path(information), after: comment.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

    it "more commented,has before and after" do
      count = Settings.paginate_per_page*5
      scrip = create(:scrip)
      information = create :information, infoable: scrip

      create_list(:comment, count, scrip: scrip )
      comment = create(:comment,scrip: scrip )
      create_list(:comment, count, scrip: scrip )

      res = auth_json_get users_commented_path(information), after: comment.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)

      res = auth_json_get users_commented_path(information), after: comment.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end

  end



  context "users shared" do

    it "no shared" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      res = auth_json_get users_shared_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "one shared" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create :information_share_record, information: information, user: create(:user)
      res = auth_json_get users_shared_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end

    it "two shared" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create :information_share_record, information: information, user: create(:user)
      create :information_share_record, information: information, user: current_user
      res = auth_json_get users_shared_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(2)
    end


    it "more shared,has before and after" do
      count = Settings.paginate_per_page*5
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create_list(:information_share_record, count, information: information)
      information_share_record =  create :information_share_record, information: information, user: create(:user)
      create_list(:information_share_record, count, information: information)

      res = auth_json_get users_shared_path(information), after: information_share_record.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
      res = auth_json_get users_shared_path(information), after: information_share_record.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end
  end

  context "users visited" do

    it "no visited" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      res = auth_json_get users_visited_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(0)
    end

    it "one visited" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create :information_visit_record, information: information, user: create(:user)
      res = auth_json_get users_visited_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(1)
    end

    it "two visited" do
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create :information_visit_record, information: information, user: create(:user)
      create :information_visit_record, information: information, user: current_user

      res = auth_json_get users_visited_path(information)
      expect(res[:has_more]).to eq(false)
      expect(res[:data].size).to eq(2)
    end

    it "more visited,has before and after" do
      count = Settings.paginate_per_page*5
      scrip = create(:scrip)
      information = create :information, infoable: scrip
      create_list(:information_visit_record, count, information: information)
      information_visit_record =  create :information_visit_record, information: information, user: create(:user)
      create_list(:information_visit_record, count, information: information)

      res = auth_json_get users_visited_path(information), after: information_visit_record.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
      res = auth_json_get users_visited_path(information), after: information_visit_record.user.id
      expect(res[:has_more]).to eq(true)
      expect(res[:data].size).to eq(Settings.paginate_per_page)
    end
  end
end
