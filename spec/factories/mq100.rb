FactoryGirl.define do
  factory :mq100 do
    sequence(:service_code) {|i| "#{10000 + i}" }
    sequence(:number) {|i| "#{20000 + i}" }
    merchant
  end
end
