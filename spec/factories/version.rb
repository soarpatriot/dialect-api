FactoryGirl.define do
  factory :version do
    url "http://www.baidu.com"
    platform "android"
    sequence(:code) {|i| "#{i}" }
    mandatory true
  end
end
