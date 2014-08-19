FactoryGirl.define do
  factory :user do
    sequence(:mobile_number) {|i| (1300000000 + i).to_s }
    password "12345678"
    sequence(:nickname) {|i| "inkash-#{i}"}
    soundink_code
  end

  factory :owner, class: User do
    sequence(:mobile_number) {|i| (1400000000 + i).to_s }
    password "12345678"
    sequence(:nickname) {|i| "jigu-#{i}"}
    soundink_code
  end
end
