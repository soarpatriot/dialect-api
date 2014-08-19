FactoryGirl.define do
  factory :merchant do
    sequence(:email) {|i| "email#{i}@example.com" }
    # password "secret09"
    sequence(:name) {|i| "merchant-#{i}"}
  end
end
