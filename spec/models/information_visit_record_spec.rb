require 'spec_helper'

RSpec.describe InformationVisitRecord, :type => :model do
  it "invalid without user or information" do
    ivr = build :information_visit_record, user: nil, information: nil
    expect(ivr).not_to be_valid

    ivr = build :information_visit_record, user: nil
    expect(ivr).not_to be_valid

    ivr = build :information_visit_record, information: nil
    expect(ivr).not_to be_valid
  end
end
