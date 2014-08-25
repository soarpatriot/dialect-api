require "spec_helper"

describe V2::FeedbacksApi do
  let(:feedbacks_path) { "/v2/feedbacks" }


  context "post feedback" do
    it "with content" do
      feed_content =  "sdfasdfasdf"
      res = auth_json_post feedbacks_path, content: feed_content
      feedback = Feedback.where(user:current_user).first
      expect(feedback.content).to eq(feed_content)
    end
    it "content with whitespace" do
      feed_content =  "  "
      res = auth_json_post feedbacks_path, content: feed_content
      expect(res[:error]).to eq( I18n.t("feedbacks.content_blank_not_allow") )
    end
    it "content blank" do
      feed_content =  ""
      res = auth_json_post feedbacks_path, content: feed_content
      expect(res[:error]).to eq( I18n.t("feedbacks.content_blank_not_allow") )
    end
  end

end
