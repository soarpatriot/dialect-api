FactoryGirl.define do
  factory :coupon do
    amount 12.12
    expire_at DateTime.now + 7.days
    owner factory: :merchant
    status "usable"
    title "coupon"
    count 10
  end
end
