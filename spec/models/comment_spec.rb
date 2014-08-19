require 'rails_helper'

RSpec.describe Comment, :type => :model do

  it "increase and decrease information comments count" do
    scrip = create :scrip
    comment = create :comment, scrip: scrip
    expect(scrip.information.comments_count).to eq(1)
    comment.destroy
    expect(scrip.information.comments_count).to eq(0)
  end

end
