require 'spec_helper'
require 'carrierwave/test/matchers'

describe ScripImageUploader do
  include CarrierWave::Test::Matchers
  path_to_file = "#{G2.config.root_dir}/app/assets/images/scrips/day1.jpg"
  before do
    scrip = create :scrip
    ScripImageUploader.enable_processing = true
    @uploader = ScripImageUploader.new(scrip, :image)
    @uploader.store!(File.open(path_to_file))
  end

  after do
    ScripImageUploader.enable_processing = false
    # @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 64 by 64 pixels" do
      @uploader.thumb.should have_dimensions(160, 160)
    end
  end



end