require "spec_helper"

describe V1::PostsApi do

  let(:post_path) { "/v1/posts" }


  context "post" do

    it "fail" do
      res = auth_json_post post_path, content:"sss"
      expect(res[:error]).to eq("image is missing, sound is missing")
    end

    it "succes" do
      image = File.open("#{G2.config.root_dir}/app/assets/images/day3.jpg")
      sound = File.open("#{G2.config.root_dir}/app/assets/sound/xiatian.mp3")
      res = auth_json_post post_path, content:"sss", image:image, sound:sound
      expect(res[:code]).to eq(0)
    end

  end

end
