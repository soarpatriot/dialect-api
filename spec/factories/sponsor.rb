FactoryGirl.define do
  factory :sponsor do
    sequence(:title) {|i| "merchant #{i}" }
  end
end
