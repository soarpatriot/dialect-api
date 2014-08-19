FactoryGirl.define do
  factory :soundink_code do
    sequence(:service_code) {|i| (10000 + i).to_s }
  end
end
