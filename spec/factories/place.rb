FactoryGirl.define do
  factory :place do
    sequence(:name) {|i| "place #{i}" }
  end
end
